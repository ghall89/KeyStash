import SwiftUI
import AppKit
import Observation

struct LicenseInfoRow: View {
	@EnvironmentObject var viewModes: ViewModes
	@Binding var showToast: Bool
	@Binding var value: String
	var label: String
	
	var body: some View {
		HStack(alignment: .top) {
			if value.count > 0 || viewModes.editMode == true {
				Button(action: {
					copyToClipboard(value: value)
				}, label: {
					Image(systemName: "doc.on.doc.fill")
						.foregroundStyle(.accent)
				})
				.buttonStyle(.plain)
				.disabled(viewModes.editMode)
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					if viewModes.editMode == true {
						TextField(getPlaceholderText(), text: $value)
							.textFieldStyle(.plain)
							.lineLimit(label == "License Key" ? 10 : 1)
					} else {
						Text(value)
					}
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
	}
	
	private func getPlaceholderText() -> String {
		switch label {
			case "Registered To":
				return "Johnny Appleseed"
			case "Email":
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
		if showToast == false {
			showToast.toggle()
		}
	}
}
