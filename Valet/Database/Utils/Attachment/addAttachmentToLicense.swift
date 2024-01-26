import Foundation
import GRDB

func addAttachmentToLicense(_ dbQueue: DatabaseQueue, data: License, attachment: Attachment) throws {
	do {
		try dbQueue.write { db in
			try attachment.insert(db)
			
			// update license w/ attachment id
			let columns: [ColumnAssignment] = [
				Column("attachmentId").set(to: attachment.id)
			]
			
			try License
				.filter(Column("id") == data.id)
				.updateAll(db, columns)
			
		}
	} catch {
		print("error: \(error)")
	}
}
