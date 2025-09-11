import Foundation
import GRDB

final class DatabaseService {
	var fileService: FileService
	var debugEnv: Bool
	var dbQueue: DatabaseQueue?

	init() {
		fileService = .init()
		debugEnv = ProcessInfo.processInfo.environment["DYLD_INSERT_LIBRARIES"] != nil
		try! connectToDb()
	}

	func connectToDb() throws {
		do {
			let dbPath = try fileService.getDirectoryPath(
				!debugEnv ? .documentDirectory : .developerDirectory
			).appendingPathComponent("db.sqlite")

			dbQueue = try DatabaseQueue(path: dbPath.absoluteString)

			if let dbQueue = dbQueue {
				try migrations(dbQueue)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	func addLicense(data: License) throws {
		dbWrite { db in
			try data.insert(db)
		}
	}

	func deleteLicense(license: License) throws {
		dbWrite { db in
			// delete given license by id
			try License
				.filter(Column("id") == license.id)
				.deleteAll(db)
		}
	}

	func updateLicense(data: License) throws {
		dbWrite { db in
			// define updated license doc
			let columns: [ColumnAssignment] = [
				Column("icon").set(to: data.icon),
				Column("softwareName").set(to: data.softwareName),
				Column("downloadUrlString").set(to: data.downloadUrlString),
				Column("version").set(to: data.version),
				Column("attachmentPath").set(to: data.attachmentPath),
				Column("registeredToName").set(to: data.registeredToName),
				Column("registeredToEmail").set(to: data.registeredToEmail),
				Column("licenseKey").set(to: data.licenseKey),
				Column("purchaseDt").set(to: data.purchaseDt),
				Column("expirationDt").set(to: data.expirationDt),
				Column("notes").set(to: data.notes),
				Column("updatedDate").set(to: Date()),
				Column("inTrash").set(to: data.inTrash),
				Column("trashDate").set(to: data.inTrash ? Date() : nil),
			]

			// write update to db
			try License
				.filter(Column("id") == data.id)
				.updateAll(db, columns)
		}
	}

	func moveToFromTrashById(_ ids: Set<String>, inTrash: Bool) {
		dbWrite { db in
			let updates: [ColumnAssignment] = [
				Column("inTrash").set(to: inTrash),
				Column("trashDate").set(to: inTrash ? Date() : nil),
				Column("updatedDate").set(to: Date()),
			]
			
			try License
				.filter(ids.contains(Column("id")))
				.updateAll(db, updates)
		}
	}

	func emptyTrash() {
		dbWrite { db in
			let trashFilterPredicate = Column("inTrash") == true

			// delete all license docs marked inTrash
			try License
				.filter(trashFilterPredicate)
				.deleteAll(db)
		}
	}

	private func dbWrite(_ function: (_ db: Database) throws -> Void) {
		do {
			try dbQueue!.write { db in
				try function(db)
			}
		} catch {
			logger.error("Database write failed: \(error)")
		}
	}
}
