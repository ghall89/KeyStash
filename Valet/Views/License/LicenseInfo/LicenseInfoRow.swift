import SwiftUI

struct LicenseInfoRow: View {
	@Binding var showToast: Bool
	var value: String
	var label: String
	
	var body: some View {
		HStack(alignment: .top) {
			if value.count > 0 {
				Button(action: copyAction, label: {
					Image(systemName: "doc.on.doc.fill")
						.foregroundStyle(.accent)
						.contentTransition(.symbolEffect(.replace.downUp.byLayer))
				})
				.frame(width: 12)
				.buttonStyle(.plain)

				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					Text(value)
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
		showToast.toggle()
	}
}
