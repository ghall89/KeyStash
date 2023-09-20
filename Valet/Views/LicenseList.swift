import SwiftUI
import AppKit
import SwiftData

struct LicenseList: View {
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject var viewModes: ViewModes
	@Query private var items: [License]
	
	@State var searchString: String = ""
	
	var body: some View {
		List {
			NSSearchFieldWrapper(searchText: $searchString)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			ForEach(items
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
					Button("Delete", role: .destructive, action: {
						let index = IndexSet(integer: items.firstIndex(of: item)!)
						deleteItems(offsets: index)
					})
				}
			}
			.onDelete(perform: deleteItems)
		}
		.toolbar {
			if viewModes.splitViewVisibility != NavigationSplitViewVisibility.detailOnly {
				ToolbarItem {
					Button(action: {
						viewModes.showNewAppSheet.toggle()
					}) {
						Label("Add Item", systemImage: "plus")
					}
				}
			}
		}
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				modelContext.delete(items[index])
			}
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
