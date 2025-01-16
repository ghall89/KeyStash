import SwiftUI

struct LicenseHeader: View {
	var license: License
	
	init(_ license: License) {
		self.license = license
	}
	
	var body: some View {
		HStack {
			Image(nsImage: license.iconNSImage)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 75)
			VStack(alignment: .leading) {
				Text(license.softwareName)
					.font(.title)
					.multilineTextAlignment(.leading)
				if let version = license.version {
					if !version.isEmpty {
						Text(version)
					}
				}
				if let purchaseDt = license.purchaseDt {
					Text("Purchased \(purchaseDt.formatted(date: .abbreviated, time: .omitted))")
				}
			}
			Spacer()
			if let url = license.downloadUrl {
				Link(destination: url, label: {
					if isDownloadLink(url: url) {
						Label("Download", systemImage: "arrow.down.circle")
					} else {
						Label("Website", systemImage: "safari")
					}
				})
				.buttonStyle(.borderless)
				.foregroundStyle(Color.accent)
			}
		}
		.padding()
	}
}
