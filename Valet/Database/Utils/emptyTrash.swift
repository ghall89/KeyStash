import Foundation
import GRDB

func emptyTrash() {
	do {
		let dbQueue = try connectToDb()
		
		try dbQueue?.write { db in
			try License
				.filter(Column("inTrash") == true)
				.deleteAll(db)
		}
	} catch {
		print(error)
	}
}
