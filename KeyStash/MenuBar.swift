import SwiftUI

struct MenuBar: Commands {
	@Environment(\.openWindow) private var openWindow
	
	@Binding var appState: AppState
	var databaseManager: DatabaseManager
	var licenses: [License]

	var body: some Commands {
		CommandGroup(replacing: .appInfo, addition: {
			Button("About KeyStash") {
				openWindow(id: "about")
			}
		})
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App") {
				appState.showNewAppSheet.toggle()
			}
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Divider()
			Button("Import") {
				importCSV(databaseManager.dbQueue)
			}
			Button("Export") {
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
