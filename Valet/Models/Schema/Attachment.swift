import Foundation
import GRDB

struct Attachment: Identifiable, Codable, FetchableRecord, PersistableRecord {
	var id: UUID = UUID()
	var filename: String = ""
	var data: Data = Data()
	var addedDate: Date = Date()
	var updatedDate: Date?
	
	init(filename: String, data: Data, updatedDate: Date? = nil) {
		self.filename = filename
		self.data = data
		self.updatedDate = updatedDate
	}
}

