import Foundation
import GRDB

struct Attachment: Identifiable, Codable, FetchableRecord, PersistableRecord {
	var id: UUID = UUID()
	var filename: String
	var path: URL
	
	init(filename: String, path: URL) {
		self.filename = filename
		self.path = path
	}
}

