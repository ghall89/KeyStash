import Foundation
import GRDB

// initiate connection to sqlite db

func connectToDb() throws -> DatabaseQueue? {
	let fileManager = FileManager.default
	do {
		let dbPath = try fileManager.url(
			for: .documentDirectory,
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


