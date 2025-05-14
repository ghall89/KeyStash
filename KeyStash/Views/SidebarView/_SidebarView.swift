import SwiftUI

struct _SidebarView: View {
	@EnvironmentObject var appState: AppState

	let buttons: [SidebarButtonProps] = [
		SidebarButtonProps(key: SidebarSelection.all, label: "All", icon: ""),
		SidebarButtonProps(key: SidebarSelection.expired, label: "Expired", icon: ""),
		SidebarButtonProps(key: SidebarSelection.deleted, label: "Deleted", icon: ""),
	]

	var body: some View {
		ForEach(buttons, id: \.self) { button in
			Button(button.label, systemImage: button.icon, action: {
				appState.sidebarSelection = button.key
			})
		}
	}
}

struct SidebarButtonProps: Hashable {
	var key: SidebarSelection
	var label: String
	var icon: String
}
