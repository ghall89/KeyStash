import SwiftUI

struct MenuBar: Commands {
	@Binding var appState: AppState
	var licenses: [License]

	var body: some Commands {
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App", action: {
				appState.showNewAppSheet.toggle()
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Divider()
//			Button("Import", action: {
//				importCSV()
//			})
			Button("Export", action: {
				exportCSV(licenses: licenses)
			})
		}
//		CommandGroup(replacing: CommandGroupPlacement.sidebar) {
//			Button("Toggle Edit Mode", action: {
//				appState.editMode.toggle()
//			})
//			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("E")))
//			Divider()
//		}
	}
}
