import SwiftUI

struct SortMenu: View {
	@AppStorage("selectedSort") var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") var selectedSortOrder: OrderOptions = .asc

	var body: some View {
		Menu(content: {
			Picker("Sort By", selection: $selectedSort, content: {
				ForEach(SortOptions.allCases, id: \.self) { sortOption in
					Label(sortOption.localizedString(), systemImage: sortOption.icon())
						.tag(sortOption)
				}
			})
			.pickerStyle(.inline)
			.labelsHidden()
			Picker("Sort Order", selection: $selectedSortOrder, content: {
				ForEach(OrderOptions.allCases, id: \.self) { orderOption in
					Label(orderOption.localizedString(), systemImage: orderOption.icon())
						.tag(orderOption)
				}
			})
			.pickerStyle(.inline)
			.labelsHidden()
		}, label: {
			Label("Sort By", systemImage: "arrow.up.arrow.down")
		})
	}
}
