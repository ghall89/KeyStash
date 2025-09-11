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
				Button("Copy Registered To", systemImage: "document.on.document.fill") {
					stringToClipboard(value: item.registeredToName)
				}
				.disabled(item.registeredToName.isEmpty)
				Button("Copy Email", systemImage: "document.on.document.fill") {
					stringToClipboard(value: item.registeredToEmail)
				}
				.disabled(!item.registeredToEmail.isEmpty)
				Button("Copy License Key", systemImage: "document.on.document.fill") {
					stringToClipboard(value: item.licenseKey)
				}
				.disabled(item.licenseKey.isEmpty)
				Divider()
				Button("Delete...", systemImage: "trash") {
					setTrashState(item, inTrash: true)
				}
			} else {
				Button("Restore") {
					setTrashState(item, inTrash: false)
				}
				Divider()
				Button("Permanently Delete", role: .destructive) {
					appState.confirmDeleteOne.toggle()
					appState.licenseToDelete = item
				}
			}
		}
	}
	
	private func setTrashState(_ item: License, inTrash: Bool) {
		if appState.selectedLicense.contains(item.id) {
			databaseManager.dbService.moveToFromTrashById(appState.selectedLicense, inTrash: inTrash)
		} else {
			databaseManager.dbService.moveToFromTrashById([item.id], inTrash: inTrash)
		}
		
		databaseManager.fetchData()
	}
}
