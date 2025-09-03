import Foundation
import GRDB

final class DatabaseManager: ObservableObject {
	@Published var dbService = DatabaseService()
	@Published var licenses: [License] = []

	// fetch current license data
	func fetchData() {
		do {
			try dbService.dbQueue!.read { db in
				self.licenses = try License.fetchAll(db)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	func getCount(_ key: SidebarSelection) -> Int {
		let today = Date()

		switch key {
			case .all:
				return licenses.filter { $0.inTrash != true }.count
			case .expired:
				return licenses.filter { $0.inTrash == false && $0.expirationDt ?? today < today }.count
			case .deleted:
				return licenses.filter { $0.inTrash == true }.count
		}
	}
}
