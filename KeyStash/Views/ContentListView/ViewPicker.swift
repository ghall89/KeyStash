import SwiftUI

struct ViewPicker: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		Picker("View", selection: $appState.sidebarSelection, content: {
			Text("All")
				.badge(databaseManager.badgeCount.total)
				.tag("all_apps")
			if databaseManager.badgeCount.expired > 0 {
				Text("Expired")
					.badge(databaseManager.badgeCount.expired)
					.tag("expired")
			}
			Text("Trash")
				.badge(databaseManager.badgeCount.inTrash)
				.tag("trash")
			
		})
	}
}
