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

	// Recreate table to remove UNIQUE constraint on attachmentPath (not supported by CloudKit)
	// and add DEFAULT values to NOT NULL columns (required for CloudKit sync).
	migrator.registerMigration("v4_cloudkit") { db in
		try #sql("""
			CREATE TABLE "license_new" (
			  "id" TEXT NOT NULL PRIMARY KEY,
			  "softwareName" TEXT NOT NULL DEFAULT '',
			  "version" TEXT,
			  "icon" BLOB,
			  "expirationDt" DATE,
			  "purchaseDt" DATE,
			  "licenseKey" TEXT NOT NULL DEFAULT '',
			  "registeredToName" TEXT NOT NULL DEFAULT '',
			  "registeredToEmail" TEXT NOT NULL DEFAULT '',
			  "downloadUrlString" TEXT NOT NULL DEFAULT '',
			  "notes" TEXT NOT NULL DEFAULT '',
			  "createdDate" DATE NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now')),
			  "updatedDate" DATE,
			  "inTrash" BOOLEAN NOT NULL DEFAULT 0,
			  "trashDate" DATE,
			  "attachmentPath" TEXT
			)
			""").execute(db)
		try #sql("""
			INSERT INTO "license_new"
			SELECT
			  "id",
			  COALESCE("softwareName", ''),
			  "version",
			  "icon",
			  "expirationDt",
			  "purchaseDt",
			  COALESCE("licenseKey", ''),
			  COALESCE("registeredToName", ''),
			  COALESCE("registeredToEmail", ''),
			  COALESCE("downloadUrlString", ''),
			  COALESCE("notes", ''),
			  COALESCE("createdDate", strftime('%Y-%m-%d %H:%M:%f', 'now')),
			  "updatedDate",
			  COALESCE("inTrash", 0),
			  "trashDate",
			  "attachmentPath"
			FROM "license"
			""").execute(db)
		try #sql("""
			DROP TABLE "license"
			""").execute(db)
		try #sql("""
			ALTER TABLE "license_new" RENAME TO "license"
			""").execute(db)
	}

	try! migrator.migrate(database)

	return database
}
