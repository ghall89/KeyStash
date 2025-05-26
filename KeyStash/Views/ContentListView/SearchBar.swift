import SwiftUI

struct SearchBar: View {
	@Environment(\.colorScheme) private var colorScheme
	@Binding var searchString: String

	var body: some View {
		VStack {
			TextField("Search", text: $searchString)
				.textFieldStyle(SearchTextFieldStyle(text: $searchString))
				.padding(8)
		}
		.padding(0)
		.background {
			VStack {
				Spacer()
				Rectangle()
					.fill(colorScheme == .dark ? Color.black : Color.border)
					.frame(height: 1)
			}
			.background {
				Rectangle()
					.fill(Material.bar)
			}
		}
	}
}
