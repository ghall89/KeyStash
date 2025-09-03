import SwiftUI

struct ContentListItem: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	
	var matchString: String
	var item: License
	
	var body: some View {
		NavigationLink(
			value: item,
			label: {
				HStack {
					Image(nsImage: item.listIcon)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 42)
					VStack(alignment: .leading) {
						HighlightableText(text: item.softwareName, highlight: matchString)
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
				Button("Delete...", role: .destructive) {
					toggleTrashState(item)
				}
			} else {
				Button("Restore") {
					toggleTrashState(item)
				}
				Divider()
				Button("Permanently Delete", role: .destructive) {
					appState.confirmDeleteOne.toggle()
					appState.licenseToDelete = item
				}
			}
		}
	}
	
	private func toggleTrashState(_ item: License) {
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
