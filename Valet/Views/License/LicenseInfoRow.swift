import SwiftUI
import AppKit
import Observation

struct LicenseInfoRow: View {
	@Binding var canEdit: Bool
	@Binding var value: String
	var label: String
	
	var body: some View {
		HStack {
			Button(action: {
				copyToClipboard(value: value)
			}, label: {
				Image(systemName: "doc.on.doc.fill")
			})
			.buttonStyle(.plain)
			.disabled(canEdit)
			VStack(alignment: .leading) {
				Text(label)
					.font(.caption)
				if canEdit == true {
					TextField(getPlaceholderText(), text: $value)
						.textFieldStyle(.plain)
				} else {
					Text(value)
				}
			}
			.multilineTextAlignment(.leading)
			Spacer()
		}
	}
	
	private func getPlaceholderText() -> String {
		switch label {
			case "Registered Name":
				return "Johnny Appleseed"
			case "Registered Email":
				return "sample@email.com"
			case "License Key":
				return "XX-XXXX-XXXX-XXXX-XXXX"
			default:
				return "Lorem ipsum..."
		}
	}
	
	private func copyToClipboard(value: String) {
		let clipboard = NSPasteboard.general
		clipboard.clearContents()
		clipboard.setString(value, forType: .string)
	}
}
