import Combine
import OSLog
import SQLiteData
import SwiftUI
import Dependencies

let logger = Logger(subsystem: "com.ghalldev.KeyStash", category: "keystash-logging")

@main
struct ValetApp: App {
	@StateObject private var databaseManager = DatabaseManager()
	@State private var appState = AppState()
	@StateObject private var editFormState = EditFormState()
	@StateObject private var settingsState = SettingsState()

	init() {
		prepareDependencies {
			$0.defaultDatabase = appDatabase(path: appDatabasePath())
		}
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(databaseManager)
				.environmentObject(appState)
				.environmentObject(editFormState)
				.environmentObject(settingsState)
				.onAppear {
					Task {
						@Dependency(\.applicationScanner) var applicationScanner
						_ = try? await applicationScanner()
					}
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
			AppSettingsView(databaseManager: databaseManager, licenses: databaseManager.licenses)
				.frame(width: 400)
				.environmentObject(settingsState)
		}
	}
}
