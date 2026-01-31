import SwiftUI

struct ContentListItem: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	
	@State var confirmMoveToTrash = false
	@State var targetItemId: String?
	
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
					targetItemId = item.id
					confirmMoveToTrash.toggle()
				}
			} else {
				Button("Restore") {
					targetItemId = item.id
					setTrashState(inTrash: false)
				}
				Divider()
				Button("Permanently Delete", role: .destructive) {
					appState.confirmDeleteOne.toggle()
					appState.licenseToDelete = item
				}
			}
		}
		.confirmationDialog(
			appState.selectedLicense.contains(targetItemId ?? "") && appState.selectedLicense.count > 1 ?
			"Are you sure you want to delete these licenses?" :
			"Are you sure you want to delete this license?",
			isPresented: $confirmMoveToTrash,
			actions: {
				Button("Delete License", role: .destructive) {
					setTrashState(inTrash: true)
				}
				Button("Cancel", role: .cancel) {
					targetItemId = nil
				}
			}, message: {
				if appState.selectedLicense.contains(targetItemId ?? ""), appState.selectedLicense.count > 1 {
					Text("These \(appState.selectedLicense.count) licenses will be moved to Recently Deleted.")
				} else {
					Text("This license will be moved to Recently Deleted.")
				}
			 }
		)
	}
	
	private func setTrashState(inTrash: Bool) {
		if appState.selectedLicense.contains(targetItemId!) {
			databaseManager.dbService.moveToFromTrashById(appState.selectedLicense, inTrash: inTrash)
		} else {
			databaseManager.dbService.moveToFromTrashById([item.id], inTrash: inTrash)
		}
		
		databaseManager.fetchData()
		targetItemId = nil
	}
}
