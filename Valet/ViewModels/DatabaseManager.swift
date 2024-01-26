import Foundation
import GRDB

class DatabaseManager: ObservableObject {
	@Published var dbQueue: DatabaseQueue
	@Published var licenses: [License] = []
	@Published var attachments: [Attachment] = []
	
	// initialize db connection
	init() {
		do {
			self.dbQueue = try connectToDb()!
		} catch {
			fatalError("Failed to connect to the database: \(error)")
		}
	}
	
	// fetch current license data
	func fetchData() {
		do {
			try dbQueue.read { db in
				self.licenses = try License.fetchAll(db)
				self.attachments = try Attachment.fetchAll(db)
			}
		} catch {
			print("Error fetching data: \(error)")
		}
	}
}
