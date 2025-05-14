import Foundation
import GRDB

class DatabaseService {
	var fileManager: FileManager
	var debugEnv: Bool
	var dbQueue: DatabaseQueue?

	init() {
		fileManager = FileManager.default
		debugEnv = ProcessInfo.processInfo.environment["DYLD_INSERT_LIBRARIES"] != nil
		try! connectToDb()
	}

	func connectToDb() throws {
		do {
			let dbPath = try fileManager.url(
				for: !debugEnv ? .documentDirectory : .developerDirectory,
				//			for: .documentDirectory,y
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
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
		do {
			// write data to db
			try dbQueue!.write { db in
				try data.insert(db)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	func deleteLicense(license: License) throws {
		do {
			try self.dbQueue!.write { db in
				// if a license doc has an attachment, delete attachment
//				if license.attachmentPath != nil {
//					logger.log("Deleting attachment...")
//					try deleteAttachment(dbQueue, license: license)
//				}

				// delete given license by id
				try License
					.filter(Column("id") == license.id)
					.deleteAll(db)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	func updateLicense(data: License) throws {
		do {
			try dbQueue!.write { db in
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
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	func emptyTrash() {
		do {
			try self.dbQueue!.write { db in
				let trashFilterPredicate = Column("inTrash") == true

				// get all license docs marked "inTrash" with attachments
				let licensesWithAttachments = try License
					.filter(trashFilterPredicate && Column("attachmentPath") != nil)
					.fetchAll(db)

				// iterate through licensesWithAttachments and delete attachments
				for lwa in licensesWithAttachments {
					if let attachmentPath = lwa.attachmentPath {
						if fileManager.fileExists(atPath: attachmentPath.path) {
							do {
								try fileManager.trashItem(at: attachmentPath, resultingItemURL: nil)
							} catch {
								logger.error("Failed to trash item at \(attachmentPath): \(error)")
							}
						} else {
							logger.warning("File does not exist at path \(attachmentPath)")
						}
					}
				}

				// delete all license docs marked inTrash
				try License
					.filter(trashFilterPredicate)
					.deleteAll(db)
			}
		} catch {
			logger.error("Database write failed: \(error)")
		}
	}
}
