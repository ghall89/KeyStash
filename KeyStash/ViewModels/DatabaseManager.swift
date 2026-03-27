import Foundation
import SQLiteData

final class DatabaseManager: ObservableObject {
	@Published var licenses: [License] = []
	@Dependency(\.defaultDatabase) private var database

	// fetch current license data
	func fetchData() {
		do {
			try database.read { db in
				self.licenses = try License.fetchAll(db)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	func addLicense(data: License) throws {
		dbWrite { db in
			try License.insert { data }
				.execute(db)
		}
	}

	func deleteLicense(license: License) throws {
		dbWrite { db in
			try License.delete(license)
				.execute(db)
		}
	}

	func updateLicense(data: License) throws {
		dbWrite { db in
			var updatedLicense = data
			updatedLicense.updatedDate = Date()
			updatedLicense.trashDate = data.inTrash ? Date() : nil

			try License.update(updatedLicense)
				.execute(db)
		}
	}

	func moveToFromTrashById(_ ids: Set<String>, inTrash: Bool) {
		guard !ids.isEmpty else { return }

		dbWrite { db in
			let now = Date()
			try License.update {
				$0.inTrash = #bind(inTrash)
				$0.trashDate = #bind(inTrash ? now : nil)
				$0.updatedDate = #bind(now)
			}
			.where { $0.id.in(ids) }
			.execute(db)
		}
	}

	func emptyTrash() {
		dbWrite { db in
			try License.delete()
				.where(\.inTrash)
				.execute(db)
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

	private func dbWrite(_ function: (_ db: Database) throws -> Void) {
		do {
			try database.write { db in
				try function(db)
			}
		} catch {
			logger.error("Database write failed: \(error)")
		}
	}
}
