import AppKit
import Foundation

// store given string in user's clipboard

func stringToClipboard(value: String) {
	let clipboard = NSPasteboard.general

	// ensure user clipboard is empty
	clipboard.clearContents()

	// set string to clipboard
	clipboard.setString(value, forType: .string)
}
