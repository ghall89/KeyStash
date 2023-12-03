import Foundation
import GRDB

class DatabaseManager: ObservableObject {
	@Published var dbQueue: DatabaseQueue
	@Published var licenses: [License] = []
	
	init() {
		do {
			self.dbQueue = try connectToDb()!
		} catch {
			fatalError("Failed to connect to the database: \(error)")
		}
	}
	
	func fetchData() {
		do {
			try dbQueue.read { db in
				self.licenses = try License.fetchAll(db)
			}
		} catch {
			print("Error fetching data: \(error)")
		}
	}
}
