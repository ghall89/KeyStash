import SwiftUI
import SwiftData

struct MenuBar: Commands {
	@Query private var items: [License]
	@Binding var viewModes: ViewModes
	
	var body: some Commands {
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App", action: {
				viewModes.showNewAppSheet.toggle()
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
			Divider()
			Button("Import", action: {
				importCSV()
			})
			Button("Export", action: {
				exportCSV(licenses: items)
			})
		}
		CommandGroup(replacing: CommandGroupPlacement.sidebar) {
			Button("Edit Mode", action: {
				viewModes.editMode.toggle()
			})
			Divider()
		}
	}
}
