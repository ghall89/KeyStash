import Foundation
import GRDB

final class Tag: Identifiable, Codable, FetchableRecord, PersistableRecord {
	var id: String = UUID().uuidString
	var name: String = ""

	init(name: String) {
		self.name = name
	}
}
