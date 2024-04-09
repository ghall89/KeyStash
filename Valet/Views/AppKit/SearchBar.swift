import AppKit
import SwiftUI

struct SearchBar: View {
	@AppStorage("selectedSort") private var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") private var selectedSortOrder: OrderOptions = .asc

	@Binding var searchString: String

	var body: some View {
		VStack {
			HStack {
				NSSearchFieldWrapper(searchText: $searchString)
					.textFieldStyle(RoundedBorderTextFieldStyle())

				Menu(content: {
					Picker("Sort By", selection: $selectedSort, content: {
						ForEach(SortOptions.allCases, id: \.self) { sortOption in
							Text(sortOption.localizedString()).tag(sortOption)
						}
					})
					Picker("Sort Order", selection: $selectedSortOrder, content: {
						ForEach(OrderOptions.allCases, id: \.self) { orderOption in
							Text(orderOption.localizedString()).tag(orderOption)
						}
					})
				}, label: {
					Image(systemName: "arrow.up.arrow.down")
				})
				.menuStyle(BorderlessButtonMenuStyle())
				.frame(width: 40)
			}
			.padding(8)
		}
		.background(Material.ultraThin)
	}
}

struct NSSearchFieldWrapper: NSViewRepresentable {
	class Coordinator: NSObject, NSSearchFieldDelegate {
		var parent: NSSearchFieldWrapper

		init(parent: NSSearchFieldWrapper) {
			self.parent = parent
		}

		func controlTextDidChange(_ notification: Notification) {
			if let textField = notification.object as? NSTextField {
				parent.searchText = textField.stringValue
			}
		}
	}

	@Binding var searchText: String

	func makeNSView(context: Context) -> NSSearchField {
		let searchField = NSSearchField()
		searchField.delegate = context.coordinator
		return searchField
	}

	func updateNSView(_ nsView: NSSearchField, context _: Context) {
		nsView.stringValue = searchText
	}

	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
}
