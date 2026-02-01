import Foundation
import GRDB
import KeyStashModels
import KeyStashState

public final class DatabaseManager: ObservableObject {
	@Published public var licenses = [License]()

	@Published var dbService = DatabaseService()

	public init() {}

	/// fetch current license data
	public func fetchData() {
		do {
			try dbService.dbQueue!.read { db in
				self.licenses = try License.fetchAll(db)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	public func getCount(_ key: SideBarSelection) -> Int {
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
