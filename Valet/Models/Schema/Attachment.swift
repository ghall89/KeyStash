import Foundation
import SwiftData

@Model
class Attachment {
	var id: UUID = UUID()
	var filename: String
	var data: Data
	
	init(filename: String, data: Data) {
		self.filename = filename
		self.data = data
	}
}
