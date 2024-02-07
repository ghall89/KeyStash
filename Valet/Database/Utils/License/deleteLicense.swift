import Foundation
import GRDB

func deleteLicense(_ dbQueue: DatabaseQueue, license: License) throws {
	do {
		try dbQueue.write { db in
			
			if license.attachmentPath != nil {
				try deleteLicense(dbQueue, license: license)
			}
			
			try License
				.filter(Column("id") == license.id)
				.deleteAll(db)
		}
	} catch {
		print("Error: \(error)")
	}
}
