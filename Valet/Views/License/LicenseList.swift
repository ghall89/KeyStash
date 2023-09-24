import SwiftUI
import AppKit
import SwiftData

struct LicenseList: View {
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject var viewModes: ViewModes
	@Query private var items: [License]
	@Binding var sidebarSelection: String
	@State var searchString: String = ""
	@State var confirmDelete: Bool = false
	@State var confirmDeleteAll: Bool = false
	@State var selection: UUID? = nil
	
	var body: some View {
		List(selection: $selection) {
			NSSearchFieldWrapper(searchText: $searchString)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			ForEach(filterItems()
			) { item in
				NavigationLink(destination: {
					LicenceInfo(license: item)
				}, label: {
					Image(nsImage: item.miniIcon )
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 24)
					Text("\(item.softwareName)")
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
						Button("Delete Permenently", role: .destructive, action: {
							confirmDelete.toggle()
						})
					}
				}
				.alert("Are you sure you want to delete your \(item.softwareName) license info? Any files you have attached to it will also be deleted.", isPresented: $confirmDelete, actions: {
					Button("Delete", role: .destructive, action: {
						let index = IndexSet(integer: items.firstIndex(of: item)!)
						deleteItems(offsets: index)
						confirmDelete.toggle()
					})
					Button("Cancel", role: .cancel, action: {
						confirmDelete.toggle()
					})
				})
			}
		}
//		.onChange(of: selection, {
//			if viewModes.editMode == true {
//				viewModes.editMode.toggle()
//			}
//		})
		.animation(.easeIn, value: filterItems())
		.frame(minWidth: 340)
		.toolbar {
			if viewModes.splitViewVisibility != NavigationSplitViewVisibility.detailOnly {
				ToolbarItem {
					if sidebarSelection == "trash" {
						Button(action: {
							confirmDeleteAll.toggle()
						}, label: {
							Label("Empty Trash", systemImage: "trash.slash")
								.foregroundStyle(.red)
						})
						.disabled(!items.contains(where: { $0.inTrash == true }))
					} else {
						Button(action: {
							viewModes.showNewAppSheet.toggle()
						}) {
							Label("Add Item", systemImage: "plus")
						}
					}
				}
			}
		}
		.navigationTitle(snakeToTitleCase(sidebarSelection))
		.alert("Are you sure you want to empty the trash? Any files you have attached will also be deleted.", isPresented: $confirmDeleteAll, actions: {
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
			.sorted { $0.softwareName < $1.softwareName }
	}
	
	// search bar
	private struct NSSearchFieldWrapper: NSViewRepresentable {
		class Coordinator: NSObject, NSSearchFieldDelegate {
			var parent: NSSearchFieldWrapper
			
			init(parent: NSSearchFieldWrapper) {
				self.parent = parent
			}
			
			func controlTextDidChange(_ notification: Notification) {
				if let textField = notification.object as? NSTextField {
					parent.searchText = textField.stringValue
				}
			}
		}
		
		@Binding var searchText: String
		
		func makeNSView(context: Context) -> NSSearchField {
			let searchField = NSSearchField()
			searchField.delegate = context.coordinator
			return searchField
		}
		
		func updateNSView(_ nsView: NSSearchField, context: Context) {
			nsView.stringValue = searchText
		}
		
		func makeCoordinator() -> Coordinator {
			return Coordinator(parent: self)
		}
	}
}
