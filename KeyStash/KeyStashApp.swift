import Combine
import OSLog
import SwiftUI

let logger = Logger(subsystem: "com.ghalldev.KeyStash", category: "keystash-logging")

@main
struct ValetApp: App {
	@StateObject private var databaseManager = DatabaseManager()
	@State private var appState = AppState()
	@StateObject private var editFormState = EditFormState()
	@StateObject private var settingsState = SettingsState()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(databaseManager)
				.environmentObject(appState)
				.environmentObject(editFormState)
				.environmentObject(settingsState)
				.onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
				}
				.frame(minHeight: 260)
		}
		.commands {
			MenuBar(
				appState: $appState,
				databaseManager: databaseManager,
				licenses: databaseManager.licenses
			)
		}

		Window("About KeyStash", id: "about") {
			AboutWindowView()
				.toolbar(removing: .title)
				.toolbarBackground(.hidden, for: .windowToolbar)
				.containerBackground(.thickMaterial, for: .window)
				.windowMinimizeBehavior(.disabled)
		}
		.windowResizability(.contentSize)
		.defaultPosition(.center)
		.restorationBehavior(.disabled)

		Settings {
			AppSettingsView()
				.frame(width: 400)
				.environmentObject(settingsState)
		}
	}
}
