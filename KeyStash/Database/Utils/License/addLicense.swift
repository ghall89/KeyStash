import GRDB

// add new license docs to the db

func addLicense(_ dbQueue: DatabaseQueue, data: License) throws {
	do {
		// write data to db
		try dbQueue.write { db in
			try data.insert(db)
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
}
