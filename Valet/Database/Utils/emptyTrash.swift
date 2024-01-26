import Foundation
import GRDB

func emptyTrash(_ dbQueue: DatabaseQueue) {
	do {
		try dbQueue.read { db in
			let licenses: [License] = try License
				.filter(Column("inTrash") == true)
				.fetchAll(db)
			
			try licenses.forEach { license in
				try deleteLicense(dbQueue, license: license)
			}
		}
	} catch {
		print("Error: \(error)")
	}
}
