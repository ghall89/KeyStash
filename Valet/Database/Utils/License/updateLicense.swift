import Foundation
import GRDB

// update properties on a license document

func updateLicense(_ dbQueue: DatabaseQueue, data: License) throws {
	do {
		try dbQueue.write { db in
			
			// define updated license doc
			let columns: [ColumnAssignment] = [
				Column("softwareName").set(to: data.softwareName),
				Column("downloadUrlString").set(to: data.downloadUrlString),
				Column("attachmentPath").set(to: data.attachmentPath),
				Column("registeredToName").set(to: data.registeredToName),
				Column("registeredToEmail").set(to: data.registeredToEmail),
				Column("licenseKey").set(to: data.licenseKey),
				Column("notes").set(to: data.notes),
				Column("updatedDate").set(to: Date()),
				Column("inTrash").set(to: data.inTrash),
				Column("trashDate").set(to: data.inTrash ? Date() : nil)
			]
			
			// write update to db
			try License
				.filter(Column("id") == data.id)
				.updateAll(db, columns)
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
}
