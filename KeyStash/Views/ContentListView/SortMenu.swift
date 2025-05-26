import SwiftUI

struct SortMenu: View {
	@EnvironmentObject private var settingsState: SettingsState
	
	var body: some View {
		Menu(content: {
			Picker("Sort By", selection: $settingsState.selectedSort, content: {
				ForEach(SortOptions.allCases, id: \.self) { sortOption in
					Text(sortOption.localizedString()).tag(sortOption)
				}
			})
			Picker("Sort Order", selection: $settingsState.selectedSortOrder, content: {
				ForEach(OrderOptions.allCases, id: \.self) { orderOption in
					Text(orderOption.localizedString()).tag(orderOption)
				}
			})
		}, label: {
			Image(systemName: "arrow.up.arrow.down")
		})
	}
}
