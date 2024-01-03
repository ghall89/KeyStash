import GRDB
import AppKit

// remove attachment from database, and move file to user's trash
func deleteAttachment(_ dbQueue: DatabaseQueue, attachment: Attachment) throws {
	let fileManager = FileManager.default
	
	do {
		try dbQueue.write { db in
			try Attachment.deleteOne(db, id: attachment.id)
			try fileManager.trashItem(at: attachment.path, resultingItemURL: nil)
		}
	} catch {
		print("error: \(error)")
	}
}
