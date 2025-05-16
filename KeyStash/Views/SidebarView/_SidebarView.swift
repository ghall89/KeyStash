import SwiftUI
import AppKit

struct SidebarView: View {
	@EnvironmentObject var appState: AppState
	@EnvironmentObject private var databaseManager: DatabaseManager

	let buttons: [SidebarButtonProps] = [
		SidebarButtonProps(
			key: SidebarSelection.all,
			icon: "key.2.on.ring.fill",
			color: .blue,
		),
		SidebarButtonProps(
			key: SidebarSelection.expired,
			icon: "exclamationmark",
			color: .red
		),
		SidebarButtonProps(
			key: SidebarSelection.deleted,
			icon: "trash.fill",
			color: .orange
		),
	]

	var body: some View {
		ScrollView {
			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible())
			]) {
				ForEach(buttons, id: \.self) { button in
					SidebarItem(button: button, count: databaseManager.getCount(button.key))
				}
			}
			.padding(10)
		}
		.frame(minWidth: 240)
	}
}

struct SidebarButtonProps: Hashable {
	var key: SidebarSelection
	var icon: String
	var color: Color
}
