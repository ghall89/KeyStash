import Foundation
import GRDB

// initiate connection to sqlite db

func connectToDb() throws -> DatabaseQueue? {
	let fileManager = FileManager.default
	
	let debugEnv = isDebugEnv()
	
	do {
		let dbPath = try fileManager.url(
			for: !debugEnv ? .documentDirectory : .developerDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		).appendingPathComponent("db.sqlite")

		let dbQueue = try DatabaseQueue(path: dbPath.absoluteString)

		try migrations(dbQueue)

		return dbQueue
	} catch {
		logger.error("ERROR: \(error)")
		return nil
	}
}

private func isDebugEnv() -> Bool {
	return ProcessInfo.processInfo.environment["DYLD_INSERT_LIBRARIES"] != nil
}
