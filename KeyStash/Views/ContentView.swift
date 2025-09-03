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
			if appState.selectedLicense != nil {
				if let index = databaseManager.licenses.firstIndex(where: { $0.id == appState.selectedLicense }) {
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
					Image(systemName: "app.dashed")
						.font(.system(size: 80, weight: .thin))
						.foregroundStyle(.secondary)
					Text("Select an item")
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
