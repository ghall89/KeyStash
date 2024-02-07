import AppKit
import SwiftUI

struct NSSearchFieldWrapper: NSViewRepresentable {
	class Coordinator: NSObject, NSSearchFieldDelegate {
		var parent: NSSearchFieldWrapper
		
		init(parent: NSSearchFieldWrapper) {
			self.parent = parent
		}
		
		func controlTextDidChange(_ notification: Notification) {
			if let textField = notification.object as? NSTextField {
				parent.searchText = textField.stringValue
			}
		}
	}
	
	@Binding var searchText: String
	
	func makeNSView(context: Context) -> NSSearchField {
		let searchField = NSSearchField()
		searchField.delegate = context.coordinator
		return searchField
	}
	
	func updateNSView(_ nsView: NSSearchField, context: Context) {
		nsView.stringValue = searchText
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
}
