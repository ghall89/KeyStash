import SwiftUI
import SwiftData

@main
struct ValetApp: App {
	@State var viewModes = ViewModes()
	
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			License.self,
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Fatal Error: \(error)")
		}
	}()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(viewModes)
				.onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
				}
				.frame(minHeight: 260)
		}
		.commands {
			MenuBar(viewModes: $viewModes)
		}
		.modelContainer(sharedModelContainer)
		
		Settings {
			AppSettings()
		}
	}
}
