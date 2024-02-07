import Foundation
import GRDB

func addAttachmentToLicense(_ dbQueue: DatabaseQueue, data: License, attachment: URL) throws {
	do {
		try dbQueue.write { db in
			// update license w/ attachment
			let columns: [ColumnAssignment] = [
				Column("attachmentPath").set(to: attachment)
			]
			
			try License
				.filter(Column("id") == data.id)
				.updateAll(db, columns)
			
		}
	} catch {
		print("error: \(error)")
	}
}
