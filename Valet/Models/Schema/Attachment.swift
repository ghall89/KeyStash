import Foundation
import GRDB

struct Attachment: Identifiable, Codable, FetchableRecord, PersistableRecord {
	var id: UUID = UUID()
	var filename: String = ""
	var data: Data = Data()
	
	init(filename: String, data: Data) {
		self.filename = filename
		self.data = data
	}
}

