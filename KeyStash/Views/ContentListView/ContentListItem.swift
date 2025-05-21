import SwiftUI

struct ContentListItem: View {
	@EnvironmentObject var sidebarModel: ContentListViewModel
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	
	@AppStorage("compactList") private var compactList: Bool = false
	
	var item: License
	
	var body: some View {
		NavigationLink(
			value: item,
			label: {
				HStack {
					if compactList == false {
						Image(nsImage: item.listIcon)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 42)
					}
					VStack(alignment: .leading) {
						HighlightableText(text: item.softwareName, highlight: sidebarModel.searchString)
						if let version = item.version, version != "" {
							Text("Version \(version)")
								.font(.caption)
								.foregroundStyle(Color.primary)
								.opacity(0.8)
						}
					}
				}
				.padding(3)
			}
		)
		.contextMenu {
			if item.inTrash == false {
				Button("Move to Trash", role: .destructive) {
					moveToTrash(item)
				}
			} else {
				Button("Restore", role: .destructive) {
					moveToTrash(item)
				}
			}
		}
	}
	
	private func moveToTrash(_ item: License) {
		do {
			var updatedLicense = item
			updatedLicense.inTrash.toggle()
			try databaseManager.dbService.updateLicense(data: updatedLicense)
			databaseManager.fetchData()
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
}
