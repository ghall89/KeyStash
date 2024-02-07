import SwiftUI

@main
struct ValetApp: App {
	@StateObject var databaseManager = DatabaseManager()
	@State private var viewModes = ViewModes()
	@State private var editFormState = EditFormState()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(databaseManager)
				.environmentObject(viewModes)
				.environmentObject(editFormState)
				.onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
				}
				.frame(minHeight: 260)
		}
		.commands {
			MenuBar(viewModes: $viewModes)
		}
		
		Settings {
			AppSettings()
		}
	}
}
