import SwiftUI
import AppKit

struct AboutWindowView: View {
	
	var body: some View {
		VStack {
			HStack {
				VStack {
					Image(nsImage: NSImage(named: Bundle.main.infoDictionary?["CFBundleIconFile"] as? String ?? "AppIcon") ?? NSImage())
						.resizable()
						.frame(width: 80, height: 80)
					Text(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
					Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
					HStack(spacing: 10) {
						Button("GitHub", action: {
							openUrl("https://github.com/ghall89/keystash")
						})
						Button("Support on Ko-Fi", action: {
							openUrl("https://ko-fi.com/T6T66ELM7")
						})
					}
				}
			}
		}
		.padding()
		.frame(width: 300)
	}
	
	private func openUrl(_ url: String) {
		if let url = URL(string: url) {
			NSWorkspace.shared.open(url)
		}
	}
}

#Preview {
    AboutWindowView()
}
