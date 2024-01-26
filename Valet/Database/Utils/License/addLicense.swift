import GRDB

func addLicense(_ dbQueue: DatabaseQueue, data: License) throws {
	do {
		try dbQueue.write { db in
			try data.insert(db)
		}
	} catch {
		print("error: \(error)")
	}
}
