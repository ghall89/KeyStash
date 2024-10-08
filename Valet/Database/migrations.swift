import Foundation
import GRDB

func migrations(_ dbQueue: DatabaseQueue) throws {
	var migrator = DatabaseMigrator()
	do {
		migrator.registerMigration("v1", migrate: { db in
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
				t.column("attachmentPath", .text).unique()
			}
		})

		migrator.registerMigration("v2", migrate: { db in
			try db.alter(table: "license") { t in
				t.add(column: "expirationDt", .date)
			}
		})

		migrator.registerMigration("v3", migrate: { db in
			try db.alter(table: "license", body: { t in
				t.add(column: "purchaseDt", .date)
				t.add(column: "version", .text)
			})
		})

		try migrator.migrate(dbQueue)
	} catch {
		logger.error("ERROR: \(error)")
	}
}
