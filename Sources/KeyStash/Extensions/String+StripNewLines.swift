import Foundation

extension String {
	func stripNewLines() -> String {
		let newlines = CharacterSet.newlines
		return components(separatedBy: newlines).joined()
	}
}
