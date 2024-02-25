import Foundation
import GRDB

// delete all attachments where "inTrash == true"

func emptyTrash(_ dbQueue: DatabaseQueue) {
	do {
		try dbQueue.write { db in
			let trashFilterPredicate = Column("inTrash") == true
			
			// get all license docs marked "inTrash" with attachments
			let licensesWithAttachments = try License
				.filter(trashFilterPredicate && Column("attachmentPath") != nil)
				.fetchAll(db)
			
			// iterate through licensesWithAttachments and delete attachments
			for lwa in licensesWithAttachments {
				try deleteAttachment(dbQueue, license: lwa)
			}
			
			// delete all license docs marked inTrash
			try License
				.filter(trashFilterPredicate)
				.deleteAll(db)
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
}
