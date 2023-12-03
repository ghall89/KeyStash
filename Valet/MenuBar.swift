import SwiftUI

struct MenuBar: Commands {
	@Binding var viewModes: ViewModes
	
	var body: some Commands {
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App", action: {
				viewModes.showNewAppSheet.toggle()
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Divider()
//			Button("Import", action: {
//				importCSV()
//			})
//			Button("Export", action: {
//				exportCSV(licenses: items)
//			})
		}
		CommandGroup(replacing: CommandGroupPlacement.sidebar) {
			Button("Toggle Edit Mode", action: {
				viewModes.editMode.toggle()
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("E")))
			Divider()
		}
	}
}
