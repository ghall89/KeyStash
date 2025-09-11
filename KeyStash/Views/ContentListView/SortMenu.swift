import SwiftUI

struct SortMenu: View {
	@EnvironmentObject private var settingsState: SettingsState

	var body: some View {
		Menu(content: {
			Picker("Sort By", selection: $settingsState.selectedSort, content: {
				ForEach(SortOptions.allCases, id: \.self) { sortOption in
					Label(sortOption.localizedString(), systemImage: sortOption.icon())
						.tag(sortOption)
				}
			})
			.pickerStyle(.inline)
			Picker("Sort Order", selection: $settingsState.selectedSortOrder, content: {
				ForEach(OrderOptions.allCases, id: \.self) { orderOption in
					Label(orderOption.localizedString(), systemImage: orderOption.icon())
						.tag(orderOption)
				}
			})
			.pickerStyle(.inline)
		}, label: {
			Image(systemName: "arrow.up.arrow.down")
		})
	}
}
