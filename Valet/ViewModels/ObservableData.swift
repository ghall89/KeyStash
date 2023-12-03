import Foundation
import GRDB

class ObservableDatabase: ObservableObject {
	@Published var dbQueue: DatabaseQueue
	
	init() {
		do {
			self.dbQueue = try connectToDb()!
		} catch {
			fatalError("Failed to connect to the database: \(error)")
		}
	}
}
