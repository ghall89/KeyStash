import Foundation
import GRDB

// copy attachment file to application data and add the path to the db

func addAttachmentToLicense(_ dbQueue: DatabaseQueue, data: License, attachment: URL) throws {
	do {
		try dbQueue.write { db in
			// update license w/ attachment
			let columns: [ColumnAssignment] = [
				Column("attachmentPath").set(to: attachment),
			]

			try License
				.filter(Column("id") == data.id)
				.updateAll(db, columns)
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
}
