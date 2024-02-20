import SwiftUI
import AppKit

struct LicenseList: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var viewModes: ViewModes
	
	@Binding var sidebarSelection: String

	@State private var searchString: String = ""
	@State private var confirmDelete: Bool = false
	@State private var confirmDeleteAll: Bool = false
	@State private var selection: String? = nil
	
	@AppStorage("selectedSort") private var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") private var selectedSortOrder: OrderOptions = .asc
	@AppStorage("compactList") private var compactList: Bool = false
	@AppStorage("disableAnimations") private var disableAnimations: Bool = false
	
	var body: some View {
		ZStack(alignment: .top) {
			List(selection: $selection) {
				Section {
					EmptyView()
				}
				.listSectionSeparator(.hidden)
				.listRowSeparator(.hidden)
				Section {
					EmptyView()
				}
				.listSectionSeparator(.hidden)
				.listRowSeparator(.hidden)
				
				Section {
					ForEach(filterItems()) { item in
						NavigationLink(destination: {
							LicenceInfo(license: item)
						}, label: {
							HStack {
								if compactList == false {
									Image(nsImage: item.miniIcon )
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 24)
								}
								HighlightableText(text: item.softwareName, highlight: searchString)
								Spacer()
							}
						})
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
				}
			}
			
			SearchBar(searchString: $searchString)
		}
		.frame(minWidth: 340)
		.toolbar {
			ToolbarItem {
				if sidebarSelection == "trash" {
					Button(
						role: .destructive,
						action: {
							confirmDeleteAll.toggle()
						}, label: {
							Label("Empty Trash", systemImage: "trash.slash")
						})
//					.disabled(databaseManager.licenses.contains(where: { $0.inTrash == true }))
					.help("Empty Trash")
				} else {
					Button(action: {
						viewModes.showNewAppSheet.toggle()
					}, label: {
						Label("Add Item", systemImage: "plus")
					})
					.help("Add Item")
				}
			}
			
		}
		.onAppear(perform: databaseManager.fetchData)
		.navigationTitle(snakeToTitleCase(sidebarSelection))
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
		.sheet(isPresented: $viewModes.showNewAppSheet, content: {
			AddLicense(licenseSelection: $selection)
		})
	}
	
	private func resetSelection(itemId: String) {
		if itemId == selection {
			selection = nil
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
		
		switch sidebarSelection {
			case "all_apps":
				filteredItems = databaseManager.licenses.filter { $0.inTrash == false }
			case "trash":
				filteredItems = databaseManager.licenses.filter { $0.inTrash == true }
			default:
				filteredItems = databaseManager.licenses
		}
		return filteredItems
			.filter { searchString.count > 0 ? $0.softwareName.lowercased().contains(searchString.lowercased()) : true }
			.sorted(by: sortBy(sort: selectedSort, order: selectedSortOrder))
	}
		
}
