import Foundation
import GRDB

// delete a single license doc

func deleteLicense(_ dbQueue: DatabaseQueue, license: License) throws {
	do {
		try dbQueue.write { db in
			
			// if a license doc has an attachment, delete attachment
			if license.attachmentPath != nil {
				logger.log("Deleting attachment...")
				try deleteAttachment(dbQueue, license: license)
			}
			
			// delete given license by id
			try License
				.filter(Column("id") == license.id)
				.deleteAll(db)
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
}
