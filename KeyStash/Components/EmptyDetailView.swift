import SwiftUI

struct EmptyDetailView: View {
	let text: String
	let systemName: String

	init(_ text: String, systemName: String) {
		self.text = text
		self.systemName = systemName
	}
	
	var body: some View {
		VStack(spacing: 10) {
			Image(systemName: systemName)
				.font(.system(size: 80, weight: .thin))
				.foregroundStyle(.secondary)
			Text(text)
				.font(.title)
				.foregroundStyle(.secondary)
		}
	}
}
