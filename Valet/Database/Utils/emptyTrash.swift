import Foundation
import GRDB

// delete all attachments where "inTrash == true"
func emptyTrash(_ dbQueue: DatabaseQueue) {
	let fileManager = FileManager.default
	
	do {
		try dbQueue.write { db in
			let trashFilterPredicate = Column("inTrash") == true
			
			// get all license docs marked "inTrash" with attachments
			let licensesWithAttachments = try License
				.filter(trashFilterPredicate && Column("attachmentPath") != nil)
				.fetchAll(db)
			
			// iterate through licensesWithAttachments and delete attachments
			for lwa in licensesWithAttachments {
				if let attachmentPath = lwa.attachmentPath {
					if fileManager.fileExists(atPath: attachmentPath.path) {
						do {
							try fileManager.trashItem(at: attachmentPath, resultingItemURL: nil)
						} catch {
							logger.error("Failed to trash item at \(attachmentPath): \(error)")
						}
					} else {
						logger.warning("File does not exist at path \(attachmentPath)")
					}
				}
			}
			
			// delete all license docs marked inTrash
			try License
				.filter(trashFilterPredicate)
				.deleteAll(db)
		}
	} catch {
		logger.error("Database write failed: \(error)")
	}
}
