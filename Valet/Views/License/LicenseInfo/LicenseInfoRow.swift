import SwiftUI

struct LicenseInfoRow: View {
	@EnvironmentObject var viewModes: ViewModes
	@Binding var showToast: Bool
	var value: String
	@Binding var formValue: String
	var label: String
	@State var iconName = "doc.on.doc.fill"
	
	var body: some View {
		HStack(alignment: .top) {
			if value.count > 0 || viewModes.editMode == true {
				Button(action: copyAction, label: {
					Image(systemName: iconName)
						.foregroundStyle(.accent)
						.contentTransition(.symbolEffect(.replace.downUp.byLayer))
				})
				.frame(width: 12)
				.buttonStyle(.plain)
				.disabled(viewModes.editMode)
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					if viewModes.editMode == true {
						TextField(getPlaceholderText(), text: $formValue, axis: label == "License Key" ? .vertical : .horizontal)
							.textFieldStyle(.plain)
//							.lineLimit(label == "License Key" ? 10 : 1)
					} else {
						Text(value)
					}
				}
				.contextMenu {
					Button("Copy", action: copyAction)
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
	}
	
	private func copyAction() {
		stringToClipboard(value: value)
		iconName = "checkmark"
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			iconName = "doc.on.doc.fill"
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
}
