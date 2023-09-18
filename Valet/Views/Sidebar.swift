import SwiftUI
import SwiftData

struct Sidebar: View {
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject var viewModes: ViewModes
	@Query private var items: [License]
	
	@State var searchString: String = ""
	
	var body: some View {
		List {
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
		.searchable(text: $searchString, placement: .sidebar)
		.toolbar {
			ToolbarItem {
				Button(action: {
					viewModes.showNewAppSheet.toggle()
				}) {
					Label("Add Item", systemImage: "plus")
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
}
