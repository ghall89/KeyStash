import SwiftUI
import SwiftData
import CloudKit

@main
struct ValetApp: App {
	@State private var viewModes = ViewModes()
	@State private var editFormState = EditFormState()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
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
		.modelContainer(for: [
			License.self,
			Attachment.self,
			Tag.self
		])
		
		Settings {
			AppSettings()
		}
	}
}
