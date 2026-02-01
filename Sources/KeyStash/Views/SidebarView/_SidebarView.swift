import AppKit
import KeyStashDB
import KeyStashModels
import KeyStashState
import SwiftUI

struct SidebarView: View {
	@EnvironmentObject var appState: AppState

	@EnvironmentObject private var databaseManager: DatabaseManager

	let buttons: [SidebarButtonProps] = [
		SidebarButtonProps(
			key: SideBarSelection.all,
			icon: "key.2.on.ring.fill",
			color: Color.blue
		),
		SidebarButtonProps(
			key: SideBarSelection.expired,
			icon: "exclamationmark",
			color: Color.red
		),
		SidebarButtonProps(
			key: SideBarSelection.deleted,
			icon: "trash.fill",
			color: Color.orange
		),
	]

	var body: some View {
		ScrollView {
			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible()),
			]) {
				ForEach(buttons, id: \.self) { button in
					SidebarItem(button: button, count: databaseManager.getCount(button.key))
				}
			}
			.padding(10)
		}
	}
}

struct SidebarButtonProps: Hashable {
	var key: SideBarSelection
	var icon: String
	var color: Color
}
