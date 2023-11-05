import Foundation
import SwiftData

@Model
final class Tag: Identifiable {
	var id: UUID = UUID()
	@Relationship(inverse: \License.tags)
	var licenses: [License]? = [License]()
	var name: String = ""
	
	init(name: String) {
		self.name = name
	}
}
