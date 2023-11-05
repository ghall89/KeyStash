import SwiftUI
import AppKit
import SwiftData

struct LicenseList: View {
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject var viewModes: ViewModes
	@Query private var items: [License]
	
	@Binding var sidebarSelection: String
	
	@State private var searchString: String = ""
	@State private var confirmDelete: Bool = false
	@State private var confirmDeleteAll: Bool = false
	@State private var selection: UUID? = nil
	
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
//								if item.inTrash == true {
//									Text("?? Days")
//										.foregroundStyle(Color.red)
//								}
							}
						})
						.contextMenu {
							if item.inTrash == false {
								Button("Move to Trash", role: .destructive, action: {
									moveToTrash(item: item)
								})
							} else {
								Button("Restore", role: .destructive, action: {
									item.inTrash = false
									item.trashDate = nil
								})
							}
						}
					}
				}
			}
			.onChange(of: selection, {
				if viewModes.editMode == true {
					viewModes.editMode.toggle()
				}
			})
			.animation(disableAnimations == false ? .easeIn : nil, value: filterItems())
			
			VStack {
				HStack {
					NSSearchFieldWrapper(searchText: $searchString)
						.textFieldStyle(RoundedBorderTextFieldStyle())
					
					Menu(content: {
						Picker("Sort By", selection: $selectedSort, content: {
							ForEach(SortOptions.allCases, id: \.self) { sortOption in
								Text(sortOption.rawValue).tag(sortOption)
							}
						})
						Picker("Sort Order", selection: $selectedSortOrder, content: {
							ForEach(OrderOptions.allCases, id: \.self) { orderOption in
								Text(orderOption.rawValue).tag(orderOption)
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
		.frame(minWidth: 340)
		.toolbar {
			if viewModes.splitViewVisibility != NavigationSplitViewVisibility.detailOnly {
				ToolbarItem {
					if sidebarSelection == "trash" {
						Button(
							role: .destructive,
							action: {
								confirmDeleteAll.toggle()
							}, label: {
								Label("Empty Trash", systemImage: "trash.slash")
							})
						.disabled(!items.contains(where: { $0.inTrash == true }))
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
		}
		.navigationTitle(snakeToTitleCase(sidebarSelection))
		.confirmationDialog("Are you sure you want to empty the trash? Any files you have attached will also be deleted.", isPresented: $confirmDeleteAll, actions: {
			Button("Empty Trash", role: .destructive, action: {
				emptyTrash()
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
	
	private func resetSelection(itemId: UUID) {
		if itemId == selection {
			selection = nil
		}
	}
	
	private func moveToTrash(item: License) {
		item.inTrash = true
		item.trashDate = Date()
		resetSelection(itemId: item.id)
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				resetSelection(itemId: items[index].id)
				modelContext.delete(items[index])
			}
		}
	}
	
	private func emptyTrash() {
		
		let licensePredicate = #Predicate<License> { item in
			item.inTrash == true
		}
		selection = nil
		withAnimation {
			do {
				try modelContext.delete(model: License.self, where: licensePredicate)
			} catch {
				fatalError(error.localizedDescription)
			}
		}
	}
	
	private func filterItems() -> [License] {
		var filteredItems: [License] = []
		
		switch sidebarSelection {
			case "all_apps":
				filteredItems = items.filter { $0.inTrash == false }
			case "trash":
				filteredItems = items.filter { $0.inTrash == true }
			default:
				filteredItems = items
		}
		return filteredItems
			.filter { searchString.count > 0 ? $0.softwareName.lowercased().contains(searchString.lowercased()) : true }
			.sorted(by: sortBy(sort: selectedSort, order: selectedSortOrder))
	}
}
