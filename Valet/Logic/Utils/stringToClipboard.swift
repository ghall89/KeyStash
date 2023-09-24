import Foundation
import AppKit

func stringToClipboard(value: String) {
	let clipboard = NSPasteboard.general
	clipboard.clearContents()
	clipboard.setString(value, forType: .string)
}
