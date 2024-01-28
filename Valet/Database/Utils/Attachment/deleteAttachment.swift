import GRDB
import AppKit

// remove attachment from database, and move file to user's trash
func deleteAttachment(_ dbQueue: DatabaseQueue, attachmentId: String) throws {
	let fileManager = FileManager.default
	
	do {
		try dbQueue.write { db in
//			try fileManager.trashItem(at: attachment.path, resultingItemURL: nil)
//			try Attachment.deleteOne(db, id: attachmentId)
		}
	} catch {
		print("error: \(error)")
	}
}
