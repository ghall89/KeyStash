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
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(viewModes)
				.onAppear {
					NSWindow.allowsAutomaticWindowTabbing = false
				}
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
