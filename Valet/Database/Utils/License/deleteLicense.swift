import Foundation
import GRDB

func deleteLicense(_ dbQueue: DatabaseQueue, license: License) throws {
	do {
		if let attachmentId = license.attachmentId {
			try deleteAttachment(dbQueue, attachmentId: attachmentId)
		}
		
		try dbQueue.write { db in
			try License
				.filter(Column("id") == license.id)
				.deleteAll(db)
		}
	} catch {
		print("Error: \(error)")
	}
}
