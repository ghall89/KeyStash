import AppKit
import SwiftUI

struct LicenseListView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState

	@State private var searchString: String = ""
	@State private var confirmDelete: Bool = false
	@State private var confirmDeleteAll: Bool = false

	@AppStorage("selectedSort") private var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") private var selectedSortOrder: OrderOptions = .asc
	@AppStorage("compactList") private var compactList: Bool = false
	@AppStorage("disableAnimations") private var disableAnimations: Bool = false

	var body: some View {
		List(filterItems()) { item in
			NavigationLink(
				value: item,
				label: {
					HStack {
						if compactList == false {
							Image(nsImage: item.miniIcon)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 24)
						}
						HighlightableText(text: item.softwareName, highlight: searchString)
						if let version = item.version {
							Text(version)
								.font(.caption2)
								.foregroundStyle(Color.gray)
						}
					}
					.padding(3)
				}
			)
			.listRowSeparator(.hidden)
			.contextMenu {
				if item.inTrash == false {
					Button("Move to Trash", role: .destructive, action: {
						moveToTrash(item)
					})
				} else {
					Button("Restore", role: .destructive, action: {
						moveToTrash(item)
					})
				}
			}
		}
		.listStyle(InsetListStyle())
		.frame(minWidth: 340)
		.navigationDestination(for: License.self) { license in
			LicenceInfoView(license)
		}
		.searchable(text: $searchString)
		.toolbar {
			ToolbarItem {
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
			ToolbarItem {
				if appState.sidebarSelection == "trash" {
					Button(
						role: .destructive,
						action: {
							confirmDeleteAll.toggle()
						}, label: {
							Label("Empty Trash", systemImage: "trash.slash")
						}
					)
//					.disabled(databaseManager.licenses.contains(where: { $0.inTrash == true }))
					.help("Empty Trash")
				} else {
					Button(action: {
						appState.showNewAppSheet.toggle()
					}, label: {
						Label("Add Item", systemImage: "plus")
					})
					.help("Add Item")
				}
			}
		}
		.onAppear(perform: databaseManager.fetchData)
		.navigationTitle(LocalizedStringKey(snakeToTitleCase(appState.sidebarSelection)))
		.confirmationDialog("Are you sure you want to empty the trash? Any files you have attached will also be deleted.", isPresented: $confirmDeleteAll, actions: {
			Button("Empty Trash", role: .destructive, action: {
				emptyTrash(databaseManager.dbQueue)
				databaseManager.fetchData()
				confirmDeleteAll.toggle()
			})
			Button("Cancel", role: .cancel, action: {
				confirmDeleteAll.toggle()
			})
		})
		.sheet(isPresented: $appState.showNewAppSheet, content: {
			AddLicenseView()
		})
	}

	private func resetSelection(itemId: String) {
		if itemId == appState.selectedLicense {
			appState.selectedLicense = nil
		}
	}

	private func moveToTrash(_ item: License) {
		do {
			var updatedLicense = item
			updatedLicense.inTrash.toggle()
			try updateLicense(databaseManager.dbQueue, data: updatedLicense)
			databaseManager.fetchData()
			resetSelection(itemId: item.id)
		} catch {
			logger.error("ERROR: \(error)")
		}
	}

	private func filterItems() -> [License] {
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
			.filter { !searchString.isEmpty ? $0.softwareName.lowercased().contains(searchString.lowercased()) : true }
			.sorted(by: sortBy(sort: selectedSort, order: selectedSortOrder))
	}
}
