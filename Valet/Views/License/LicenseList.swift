import SwiftUI
import AppKit
import SwiftData

struct LicenseList: View {
	@EnvironmentObject var observableDatabase: ObservableDatabase
	@EnvironmentObject var viewModes: ViewModes
	
	@Binding var sidebarSelection: String
	
	@State private var licenses: [License] = []
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
					ForEach(licenses) { item in
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
									moveToTrash(item: item)
								})
							} else {
								Button("Restore", role: .destructive, action: {
									//									item.inTrash = false
									//									item.trashDate = nil
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
					.disabled(licenses.contains(where: { $0.inTrash == true }))
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
		//		item.inTrash = true
		//		item.trashDate = Date()
		//		resetSelection(itemId: item.id)
	}
	
	private func deleteItems(offsets: IndexSet) {
		//		withAnimation {
		//			for index in offsets {
		//				resetSelection(itemId: items[index].id)
		//				modelContext.delete(items[index])
		//			}
		//		}
	}
	
	private func emptyTrash() {
		
		//		let licensePredicate = #Predicate<License> { item in
		//			item.inTrash == true
		//		}
		//		selection = nil
		//		withAnimation {
		//			do {
		//				try modelContext.delete(model: License.self, where: licensePredicate)
		//			} catch {
		//				fatalError(error.localizedDescription)
		//			}
		//		}
	}
	
	private func getItems() {
		do {
			try observableDatabase.dbQueue.read { db in
				switch sidebarSelection {
					case "all_apps":
						licenses = try License.fetchAll(db)
					case "trash":
						licenses = try License.fetchAll(db)
					default:
						licenses = try License.fetchAll(db)
				}
			}
		} catch {
			fatalError(error.localizedDescription)
		}
		//		return dbItems
		//			.sorted(by: sortBy(sort: selectedSort, order: selectedSortOrder))
	}
}
