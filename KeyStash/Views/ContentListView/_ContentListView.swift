import SwiftUI

struct ContentListView: View {
	@EnvironmentObject private var databaseManager: DatabaseManager
	@EnvironmentObject private var appState: AppState
	@EnvironmentObject private var settingsState: SettingsState

	@State private var confirmDelete: Bool = false
	@State private var searchString: String = ""

	private var filterItems: [License] {
		var filteredItems: [License] = []
		let today = Date()

		switch appState.sidebarSelection {
			case .all:
				filteredItems = databaseManager.licenses.filter { $0.inTrash == false }
			case .expired:
				filteredItems = databaseManager.licenses.filter { $0.inTrash == false && $0.expirationDt ?? today < today }
			case .deleted:
				filteredItems = databaseManager.licenses.filter { $0.inTrash == true }
		}

		return filteredItems
			.filter { !searchString.isEmpty ? $0.softwareName.lowercased().contains(searchString.lowercased()) : true }
			.sorted(by: sortBy(sort: settingsState.selectedSort, order: settingsState.selectedSortOrder))
	}

	var body: some View {
		List(filterItems, selection: $appState.selectedLicense) { item in
			ContentListItem(matchString: searchString, item: item)
				.id(item.id)
		}
		.frame(minWidth: 240)
		.searchable(text: $searchString)
		.toolbar {
			toolbar()
		}
		.onAppear(perform: databaseManager.fetchData)
		.navigationTitle(LocalizedStringKey(snakeToTitleCase(appState.sidebarSelection.rawValue)))
		.navigationSubtitle(getSubtitle())
		.confirmationDialog("Are you sure you want to delete all items the trash? This action cannot be undone.", isPresented: $appState.confirmDeleteAll, actions: {
			Button("Empty Trash", role: .destructive) {
				databaseManager.dbService.emptyTrash()
				databaseManager.fetchData()
				appState.confirmDeleteAll.toggle()
			}
			Button("Cancel", role: .cancel) {
				appState.confirmDeleteAll.toggle()
			}
		})
		.confirmationDialog("Are you sure you want delete this license? This action cannot be undone.", isPresented: $appState.confirmDeleteOne, actions: {
			Button("Delete License", role: .destructive) {
				if let licenseToDelete = appState.licenseToDelete {
					try! databaseManager.dbService.deleteLicense(license: licenseToDelete)
					appState.licenseToDelete = nil
					databaseManager.fetchData()
					appState.confirmDeleteOne.toggle()
				}
			}
			Button("Cancel", role: .cancel) {
				appState.confirmDeleteOne.toggle()
				appState.licenseToDelete = nil
			}
		})
		.sheet(isPresented: $appState.showNewAppSheet, content: {
			AddLicenseView()
		})
	}

	private func getSubtitle() -> String {
		let itemCount = databaseManager.getCount(appState.sidebarSelection)

		return "\(itemCount) Item\(itemCount == 1 ? "" : "s")"
	}

	private func toolbar() -> some ToolbarContent {
		Group {
			if appState.splitViewVisibility != NavigationSplitViewVisibility.detailOnly {
				ToolbarItem {
					Spacer()
				}
				ToolbarItem {
					SortMenu()
				}
				ToolbarItem {
					PrimaryActionButton()
				}
			}
		}
	}

	private func resetSelection(itemId: String) {
		if itemId == appState.selectedLicense {
			appState.selectedLicense = nil
		}
	}
}
