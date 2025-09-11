import SwiftUI

struct MenuBar: Commands {
	@Environment(\.openWindow) private var openWindow
	private let csv = LicenseCSVService()
	
	@Binding var appState: AppState
	let databaseManager: DatabaseManager
	var licenses: [License]

	var body: some Commands {
		CommandGroup(replacing: .appInfo, addition: {
			Button("About KeyStash", systemImage: "info.circle") {
				openWindow(id: "about")
			}
		})
		CommandGroup(replacing: .newItem) {
			Button("Add App", systemImage: "plus") {
				appState.showNewAppSheet.toggle()
			}
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
		}
		CommandGroup(replacing: .sidebar, addition: {
			Button(SidebarSelection.all.rawValue, systemImage: "key.2.on.ring.fill") {
				appState.sidebarSelection = .all
			}
			.keyboardShortcut("1", modifiers: .command)
			Button(SidebarSelection.expired.rawValue, systemImage: "exclamationmark") {
				appState.sidebarSelection = .expired
			}
			.keyboardShortcut("2", modifiers: .command)
			Button(SidebarSelection.deleted.rawValue, systemImage: "trash.fill") {
				appState.sidebarSelection = .deleted
			}
			.keyboardShortcut("3", modifiers: .command)
			Divider()
		})
		CommandGroup(replacing: .help, addition: {
			Link(destination: URL(string: "https://github.com/ghall89/KeyStash/issues")!, label: {
				Text("Submit an Issue")
			})
		})
	}
}
