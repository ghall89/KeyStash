import Foundation
import GRDB

func addLicense(_ data: License) throws {
	do {
		let dbQueue = try connectToDb()
		
		try dbQueue?.write { db in
			try data.insert(db)
		}
	} catch {
		print(error)
	}
}
