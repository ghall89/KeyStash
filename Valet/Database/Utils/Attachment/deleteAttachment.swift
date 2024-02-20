import AppKit
import GRDB

// remove attachment from database, and move file to user's trash

func deleteAttachment(_ dbQueue: DatabaseQueue, license: License) throws {
	let fileManager = FileManager.default
	
	do {
		try dbQueue.write { db in
			if let attachmentPath = license.attachmentPath {
				try fileManager.trashItem(at: attachmentPath, resultingItemURL: nil)
				
				let columns: [ColumnAssignment] = [
					Column("attachmentPath").set(to: nil)
				]
				
				try License
					.filter(Column("id") == license.id)
					.updateAll(db, columns)
			}
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
}
