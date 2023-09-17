import SwiftUI

struct MenuBar: Commands {
	@Binding var viewModes: ViewModes
	
	var body: some Commands {
		CommandGroup(replacing: CommandGroupPlacement.newItem) {
			Button("Add App", action: {
				viewModes.showNewAppSheet.toggle()
			})
			.keyboardShortcut(KeyboardShortcut(KeyEquivalent("N")))
		}
	}
}
