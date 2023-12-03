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
		
		try migrations(dbQueue)
		
		return dbQueue
	} catch {
		print("error initializing db: \(error)")
		return nil
	}
}


