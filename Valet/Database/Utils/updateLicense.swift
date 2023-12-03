import Foundation
import GRDB

func updateLicense(_ data: License) throws {
	do {
		let dbQueue = try connectToDb()
		
		try dbQueue?.write { db in
			
			let columns: [ColumnAssignment] = [
				Column("softwareName").set(to: data.softwareName),
				Column("downloadUrlString").set(to: data.downloadUrlString),
				Column("registeredToName").set(to: data.registeredToName),
				Column("registeredToEmail").set(to: data.registeredToEmail),
				Column("licenseKey").set(to: data.licenseKey),
				Column("notes").set(to: data.notes),
				Column("updatedDate").set(to: Date()),
				Column("inTrash").set(to: data.inTrash),
				Column("trashDate").set(to: data.inTrash ? Date() : nil)
			]
			
			try License
				.filter(Column("id") == data.id)
				.updateAll(db, columns)
		}
	} catch {
		print(error)
	}
}
