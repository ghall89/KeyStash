import CloudKit
import Combine
import OSLog
import SQLiteData
import SwiftUI
import Dependencies

let logger = Logger(subsystem: "com.ghalldev.KeyStash", category: "keystash-logging")

class AppDelegate: NSObject, NSApplicationDelegate {
	@Dependency(\.defaultSyncEngine) var syncEngine

	func application(
		_ application: NSApplication,
		userDidAcceptCloudKitShareWith metadata: CKShare.Metadata
	) {
		Task { try await syncEngine.acceptShare(metadata: metadata) }
	}
}

@main
struct ValetApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject private var databaseManager = DatabaseManager()
	@State private var appState = AppState()
	@StateObject private var editFormState = EditFormState()

	init() {
		prepareDependencies {
			$0.defaultDatabase = appDatabase(path: appDatabasePath())
			#if DEBUG
			let iCloudSyncEnabled = false
			#else
			let iCloudSyncEnabled = UserDefaults.standard.object(forKey: "iCloudSyncEnabled") as? Bool ?? true
			#endif
			$0.defaultSyncEngine = try! SyncEngine(
				for: $0.defaultDatabase,
				tables: License.self,
				containerIdentifier: "iCloud.com.ghalldev.SerialBox",
				startImmediately: iCloudSyncEnabled
			)
		}
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(databaseManager)
				.environmentObject(appState)
				.environmentObject(editFormState)
				.task {
					await appState.ensureAppScannerLoaded()
				}
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
			AppSettingsView(databaseManager: databaseManager, licenses: databaseManager.licenses)
				.frame(width: 400)
				.environmentObject(appState)
		}
	}
}
