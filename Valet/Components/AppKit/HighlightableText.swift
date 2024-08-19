import AppKit
import SwiftUI

struct HighlightableText: NSViewRepresentable {
	let text: String
	let highlight: String

	func makeNSView(context _: Context) -> NSTextField {
		let textView = NSTextField()
		textView.isEditable = false
		textView.isSelectable = true
		textView.isBordered = false
		textView.drawsBackground = false

		textView.attributedStringValue = createAttributedString()

		return textView
	}

	func updateNSView(_ nsView: NSTextField, context _: Context) {
		nsView.attributedStringValue = createAttributedString()
	}

	private func createAttributedString() -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: text, attributes: nil)

		let range = text.range(of: highlight, options: .caseInsensitive)
		if let nsRange = range.flatMap({ NSRange($0, in: text) }) {
			attributedString.addAttributes([
				.foregroundColor: NSColor.orange,
			], range: nsRange)
		}

		return attributedString
	}
}
