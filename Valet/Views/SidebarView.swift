import SwiftUI

struct SidebarView: View {
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var databaseManager: DatabaseManager

	var body: some View {
		List(selection: $appState.sidebarSelection) {
			Section {
				Label("All Apps", systemImage: "square.stack")
					.badge(databaseManager.badgeCount.total)
					.tag("all_apps")
				
				if databaseManager.badgeCount.expired > 0 {
					Label("Expired", systemImage: "exclamationmark.square")
						.badge(databaseManager.badgeCount.expired)
						.tag("expired")
				}
			}
			Section {
				Label("Trash", systemImage: "trash")
					.badge(databaseManager.badgeCount.inTrash)
					.tag("trash")
			}
		}
	}
}
