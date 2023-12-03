import Foundation
import GRDB

func connectToDb() throws -> DatabaseQueue? {
	let fileManager = FileManager.default
	do {
		let dbPath = try fileManager.url(
//			for: .applicationSupportDirectory,
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		).appendingPathComponent("db.sqlite")
		
		print(dbPath.absoluteString)
		
		let dbQueue = try DatabaseQueue(path: dbPath.absoluteString)
		
		try dbQueue.write { db in
			if try !db.tableExists("license") {
				try db.create(table: "license") { t in
					t.column("id", .text).primaryKey().unique()
					t.column("softwareName", .text).notNull()
					t.column("icon", .blob)
					t.column("licenseKey", .text).notNull()
					t.column("registeredToName", .text).notNull()
					t.column("registeredToEmail", .text).notNull()
					t.column("downloadUrlString", .text).notNull()
					t.column("notes", .text).notNull()
					t.column("createdDate", .date).notNull()
					t.column("updatedDate", .date)
					t.column("inTrash", .boolean).notNull().defaults(to: false)
					t.column("trashDate", .date)
				}
			}
			
			if try !db.tableExists("attachment") {
				try db.create(table: "attachment") { t in
					t.column("id", .text).primaryKey().unique()
					t.column("filename", .text).notNull()
					t.column("data", .blob).notNull()
				}
			}
		}
		
		return dbQueue
	} catch {
		return nil
	}
}


