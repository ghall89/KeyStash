import SwiftUI

struct MenuBar: Commands {
	@Environment(\.openWindow) private var openWindow
	@Binding var appState: AppState
	var licenses: [License]

	var body: some Commands {
		CommandGroup(replacing: .appInfo, addition: {
			Button("About KeyStash", action: {
				openWindow(id: "about")
			})
		})
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App", action: {
				appState.showNewAppSheet.toggle()
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Divider()
			Button("Import", action: {
				importCSV()
			})
			.disabled(true)
			Button("Export", action: {
				exportCSV(licenses: licenses)
			})
		}
		CommandGroup(replacing: .help, addition: {
			Link(destination: URL(string: "https://github.com/ghall89/KeyStash/issues")!, label: {
				Text("Submit an Issue")
			})
		})
//		CommandGroup(replacing: CommandGroupPlacement.sidebar) {
//			Button("Toggle Edit Mode", action: {
//				appState.editMode.toggle()
//			})
//			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("E")))
//			Divider()
//		}
	}
}
