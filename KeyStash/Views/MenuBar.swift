import SwiftUI
import AppUpdater

struct MenuBar: Commands {
	@Environment(\.openWindow) private var openWindow
	@StateObject var updater = AppUpdater(owner: "ghall89", repo: "KeyStash")
	
	@Binding var appState: AppState
	var databaseManager: DatabaseManager
	var licenses: [License]

	var body: some Commands {
		CommandGroup(replacing: .appInfo, addition: {
			Button("About KeyStash") {
				openWindow(id: "about")
			}
			Button("Check for Updates...") {
				updater.check()
			}
		})
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App") {
				appState.showNewAppSheet.toggle()
			}
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Divider()
			Button("Restore") {
				importCSV(databaseManager.dbQueue, refetch: databaseManager.fetchData)
			}
			Button("Backup") {
				exportCSV(licenses: licenses)
			}
		}
		CommandGroup(replacing: .help, addition: {
			Link(destination: URL(string: "https://github.com/ghall89/KeyStash/issues")!, label: {
				Text("Submit an Issue")
			})
		})
	}
}
