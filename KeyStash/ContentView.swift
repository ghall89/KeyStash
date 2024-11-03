import SwiftUI

struct ContentView: View {
	@EnvironmentObject var appState: AppState

	var body: some View {
		NavigationSplitView(columnVisibility: $appState.splitViewVisibility) {
			LicenseListView()
				.navigationSplitViewColumnWidth(min: 340, ideal: 350)
		} detail: {
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
