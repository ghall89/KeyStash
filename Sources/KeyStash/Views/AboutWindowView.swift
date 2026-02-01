import SwiftUI

struct AboutWindowView: View {
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack {
			HStack {
				VStack {
					if let appIcon = NSImage(named: "AppIcon") {
						Image(nsImage: appIcon)
							.resizable()
							.frame(width: 80, height: 80)
							.cornerRadius(20)
					} else {
						Image(systemName: "app.dashed")
							.resizable()
							.frame(width: 80, height: 80)
							.foregroundColor(.gray)
					}
					Text(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
					Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
					HStack(spacing: 10) {
						Link("GitHub", destination: URL(string: "https://github.com/ghall89/keystash")!)
							.buttonStyle(.bordered)
						Link("Support on Ko-Fi", destination: URL(string: "https://ko-fi.com/T6T66ELM7")!)
							.buttonStyle(.bordered)
					}
				}
			}

			// Hidden button hack to close About window
			// when ESC is pressed
			Button("Dismiss") {
				dismiss()
			}
			.keyboardShortcut(.escape, modifiers: [])
			.hidden()
			.frame(width: 0, height: 0)
			.padding(0)
		}
		.padding()
		.frame(width: 300)
	}

	private func openURL(_ url: String) {
		if let url = URL(string: url) {
			NSWorkspace.shared.open(url)
		}
	}
}
