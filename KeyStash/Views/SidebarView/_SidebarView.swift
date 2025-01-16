import SwiftUI

class SidebarViewModel: ObservableObject {
	@Published var searchString: String = ""
}

struct SidebarView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState

	@StateObject var viewModel = SidebarViewModel()
	@State private var confirmDelete: Bool = false

	@AppStorage("selectedSort") private var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") private var selectedSortOrder: OrderOptions = .asc
	@AppStorage("compactList") private var compactList: Bool = false
	@AppStorage("disableAnimations") private var disableAnimations: Bool = false

	private var filterItems: [License] {
		var filteredItems: [License] = []
		let today = Date()

		switch appState.sidebarSelection {
			case "all_apps":
				filteredItems = databaseManager.licenses.filter { $0.inTrash == false }
			case "expired":
				filteredItems = databaseManager.licenses.filter { $0.inTrash == false && $0.expirationDt ?? today < today }
			case "trash":
				filteredItems = databaseManager.licenses.filter { $0.inTrash == true }
			default:
				filteredItems = databaseManager.licenses
		}

		return filteredItems
			.filter { !viewModel.searchString.isEmpty ? $0.softwareName.lowercased().contains(viewModel.searchString.lowercased()) : true }
			.sorted(by: sortBy(sort: selectedSort, order: selectedSortOrder))
	}

	var body: some View {
		List(filterItems) { item in
			SidebarItem(item: item)
		}
		.environmentObject(viewModel)
		.listStyle(.sidebar)
		.frame(minWidth: 340)
		.navigationDestination(for: License.self) { license in
			if let index = databaseManager.licenses.firstIndex(where: { $0.id == license.id }) {
				let binding = Binding<License>(
					get: { databaseManager.licenses[index] },
					set: { newValue in
						databaseManager.licenses[index] = newValue
					}
				)
				LicenseInfoView(selectedLicense: binding)
			} else {
				// Handle the case where the license isn't found
				Text("Oops, there was a problem")
			}
		}
		.searchable(text: $viewModel.searchString)
		.toolbar {
			toolbar()
		}
		.onAppear(perform: databaseManager.fetchData)
		.navigationTitle(LocalizedStringKey(snakeToTitleCase(appState.sidebarSelection)))
		.confirmationDialog("Are you sure you want to empty the trash? Any files you have attached will also be deleted.", isPresented: $appState.confirmDeleteAll, actions: {
			Button("Empty Trash", role: .destructive) {
				emptyTrash(databaseManager.dbQueue)
				databaseManager.fetchData()
				appState.confirmDeleteAll.toggle()
			}
			Button("Cancel", role: .cancel) {
				appState.confirmDeleteAll.toggle()
			}
		})
		.sheet(isPresented: $appState.showNewAppSheet, content: {
			AddLicenseView()
		})
	}

	private func toolbar() -> some ToolbarContent {
		Group {
			if appState.splitViewVisibility != NavigationSplitViewVisibility.detailOnly {
				ToolbarItem {
					ViewPicker()
				}
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
