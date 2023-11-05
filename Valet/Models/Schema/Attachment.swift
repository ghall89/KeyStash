import Foundation
import SwiftData

@Model
final class Attachment {
	var id: UUID = UUID()
//	@Relationship(inverse: \License.attachment)
	var license: License?
	var filename: String = ""
	var data: Data = Data()
	
	init(filename: String, data: Data) {
		self.filename = filename
		self.data = data
	}
}
