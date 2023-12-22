import Foundation
import GRDB

func migrations(_ dbQueue: DatabaseQueue) throws {
	var migrator = DatabaseMigrator()
	do {
		migrator.registerMigration("v1", migrate: { db in
			try db.create(table: "license") { t in
				t.column("id", .any).primaryKey().unique()
				t.column("softwareName", .text).notNull()
				t.column("icon", .blob)
				t.column("attachmentId", .any).unique()
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
			
			try db.create(table: "attachment") { t in
				t.column("id", .any).primaryKey().unique()
				t.column("filename", .text).unique()
				t.column("path", .text).unique()
			}
		})
		
		try migrator.migrate(dbQueue)
	} catch {
		print("migration failed: \(error)")
	}
}
