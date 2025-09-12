import SwiftUI

struct ContentView: View {
	@EnvironmentObject var appState: AppState
	@EnvironmentObject private var databaseManager: DatabaseManager

	var body: some View {
		NavigationSplitView(columnVisibility: $appState.splitViewVisibility) {
			SidebarView()
				.navigationSplitViewColumnWidth(min: 240, ideal: 300)
		} content: {
			ContentListView()
				.navigationSplitViewColumnWidth(min: 240, ideal: 350)
		} detail: {
			if appState.selectedLicense.count == 1 {
				if let index = databaseManager.licenses.firstIndex(where: { $0.id == appState.selectedLicense.first! as String }) {
					let binding = Binding<License>(
						get: { databaseManager.licenses[index] },
						set: { newValue in
							databaseManager.licenses[index] = newValue
						}
					)
					LicenseInfoView(selectedLicense: binding)
				} else {
					// Handle the case where the license isn't found
					Text("Oops, there was a problem")
				}
			} else {
				VStack(spacing: 10) {
					Image(systemName: appState.selectedLicense.isEmpty ? "app.dashed" : "square.3.layers.3d.down.right")
						.font(.system(size: 80, weight: .thin))
						.foregroundStyle(.secondary)
					Text(
						appState.selectedLicense.isEmpty ?
							"Select an item" :
							"\(appState.selectedLicense.count) Items Selected"
					)
					.font(.title)
					.foregroundStyle(.secondary)
				}
				.navigationSplitViewColumnWidth(min: 400, ideal: 700)
				.toolbar {
					ToolbarItem(content: {
						Spacer()
					})
				}
			}
		}
	}
}
