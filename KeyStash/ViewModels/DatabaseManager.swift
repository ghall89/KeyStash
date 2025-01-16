import Foundation
import GRDB

class DatabaseManager: ObservableObject {
	@Published var dbQueue: DatabaseQueue
	@Published var licenses: [License] = []
	@Published var badgeCount: SidebarCounts = .init(total: 0, expired: 0, inTrash: 0)

	// initialize db connection
	init() {
		do {
			dbQueue = try connectToDb()!
		} catch {
			fatalError("Failed to connect to the database: \(error)")
		}
	}

	// fetch current license data
	func fetchData() {
		do {
			try dbQueue.read { db in
				self.licenses = try License.fetchAll(db)

				let today = Date()

				self.badgeCount.total = licenses.filter { $0.inTrash != true }.count
				self.badgeCount.expired = licenses.filter { $0.inTrash == false && $0.expirationDt ?? today < today }.count
				self.badgeCount.inTrash = licenses.filter { $0.inTrash == true }.count
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	struct SidebarCounts {
		var total: Int
		var expired: Int
		var inTrash: Int
	}
}
