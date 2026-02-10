import Foundation
import SQLiteData

func appDatabasePath() -> String {
	let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

	var dbName: String = "db.sqlite"
	
	#if DEBUG
	dbName = "db-debug.sqlite"
	#endif

	return directory.appendingPathComponent(dbName).absoluteString
}

func appDatabase(path: String? = nil) -> any DatabaseWriter {
	@Dependency(\.context) var context
	var configuration: Configuration = .init()

	configuration.prepareDatabase { db in
		db.trace(options: .profile) {
			if context == .preview {
				print("\($0.expandedDescription)")
			} else {
				print("\($0.expandedDescription)")
			}
		}
	}

	let database = try! defaultDatabase(path: path, configuration: configuration)
	print("open '\(database.path)'")

	var migrator: DatabaseMigrator = .init()
	
	#if DEBUG
	migrator.eraseDatabaseOnSchemaChange = true
	#endif
	
	migrator.registerMigration("v1") { db in
		try #sql("""
			CREATE TABLE "license" (
			  "id" TEXT NOT NULL PRIMARY KEY UNIQUE,
			  "softwareName" TEXT NOT NULL,
			  "icon" BLOB,
			  "licenseKey" TEXT NOT NULL,
			  "registeredToName" TEXT NOT NULL,
			  "registeredToEmail" TEXT NOT NULL,
			  "downloadUrlString" TEXT NOT NULL,
			  "notes" TEXT NOT NULL,
			  "createdDate" DATE NOT NULL,
			  "updatedDate" DATE,
			  "inTrash" BOOLEAN NOT NULL DEFAULT 0,
			  "trashDate" DATE,
			  "attachmentPath" TEXT UNIQUE
			)
			""").execute(db)
	}

	migrator.registerMigration("v2") { db in
		try #sql("""
			ALTER TABLE "license"
			ADD COLUMN "expirationDt" DATE
			""").execute(db)
	}

	migrator.registerMigration("v3") { db in
		try #sql("""
			ALTER TABLE "license"
			ADD COLUMN "purchaseDt" DATE
			""").execute(db)
		try #sql("""
			ALTER TABLE "license"
			ADD COLUMN "version" TEXT
			""").execute(db)
	}

	try! migrator.migrate(database)

	return database
}
