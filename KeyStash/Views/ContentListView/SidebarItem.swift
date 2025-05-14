import SwiftUI

struct SidebarItem: View {
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
						Image(nsImage: item.miniIcon)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 24)
					}
					HighlightableText(text: item.softwareName, highlight: sidebarModel.searchString)
					Spacer()
					if let version = item.version {
						Text(version)
							.font(.caption2)
							.foregroundStyle(Color.primary)
							.opacity(0.8)
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
			appState.resetSelection(itemId: item.id)
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
}
