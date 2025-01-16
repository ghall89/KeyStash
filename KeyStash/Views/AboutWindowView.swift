import SwiftUI

struct AboutWindowView: View {
	var body: some View {
		VStack {
			HStack {
				VStack {
					Image("AboutIcon")
						.resizable()
						.frame(width: 80, height: 80)
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
