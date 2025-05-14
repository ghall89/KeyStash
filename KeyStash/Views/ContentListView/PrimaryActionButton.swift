import SwiftUI

struct PrimaryActionButton: View {
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		if appState.sidebarSelection == .deleted {
			Button("Empty Trash", systemImage: "trash.slash") {
				appState.confirmDeleteAll.toggle()
			}
			.help("Empty Trash")
		} else {
			Button("New License", systemImage: "plus") {
				appState.showNewAppSheet.toggle()
			}
			.help("Add new license")
		}
	}
}
