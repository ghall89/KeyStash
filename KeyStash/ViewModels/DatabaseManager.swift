import Foundation
import GRDB

class DatabaseManager: ObservableObject {
	@Published var dbService = DatabaseService()
	@Published var licenses: [License] = []
	@Published var badgeCount: SidebarCounts = .init(total: 0, expired: 0, inTrash: 0)



	// fetch current license data
	func fetchData() {
		do {
			try self.dbService.dbQueue!.read { db in
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
