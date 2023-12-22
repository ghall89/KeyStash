import Foundation
import GRDB

func emptyTrash(_ dbQueue: DatabaseQueue) {
	do {
		try dbQueue.write { db in
			try License
				.filter(Column("inTrash") == true)
				.deleteAll(db)
		}
	} catch {
		print("failed to empty trash: \(error)")
	}
}
