import SwiftUI

struct SortMenu: View {
	@AppStorage("selectedSort") private var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") private var selectedSortOrder: OrderOptions = .asc
	
	var body: some View {
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
	}
}
