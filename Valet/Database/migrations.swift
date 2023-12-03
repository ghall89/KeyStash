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
				t.column("id", .text).primaryKey().unique()
				t.column("filename", .text).notNull()
				t.column("data", .blob).notNull()
			}
		})
		
		migrator.registerMigration("v2", migrate: { db in
				try db.alter(table: "attachment", body: { t in
					t.add(column: "addedDate", .date).notNull()
					t.add(column: "updatedDate", .date)
				})
		})
		
		migrator.registerMigration("v3", migrate: { db in
			try db.alter(table: "license", body: { t in
				t.add(column: "attachmentId", .text).references("attachment", onDelete: .cascade)
			})
		})
		
		try migrator.migrate(dbQueue)
	} catch {
		print("migration failed: \(error)")
	}
}
