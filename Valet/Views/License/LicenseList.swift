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
	
	
	var body: some View {
		List {
			NSSearchFieldWrapper(searchText: $searchString)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			ForEach(filterItems()
				.filter { searchString.count > 0 ? $0.softwareName.lowercased().contains(searchString.lowercased()) : true }
				.sorted { $0.softwareName < $1.softwareName }
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
							item.inTrash = true
							item.trashDate = Date()
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
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				modelContext.delete(items[index])
			}
		}
	}
	
	private func emptyTrash() {
		
		let licensePredicate = #Predicate<License> { item in
			item.inTrash == true
		}
		
		withAnimation {
			do {
				try modelContext.delete(model: License.self, where: licensePredicate)
			} catch {
				fatalError(error.localizedDescription)
			}
		}
	}
	
	private func filterItems() -> [License] {
		switch sidebarSelection {
			case "all_apps":
				return items.filter { $0.inTrash == false }
			case "trash":
				return items.filter { $0.inTrash == true }
			default:
				return items
		}
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
