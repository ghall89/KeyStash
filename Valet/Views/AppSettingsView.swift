import LocalAuthentication
import SwiftUI

struct AppSettingsView: View {
	var body: some View {
		TabView(content: {
			GeneralSettingsView().tabItem {
				Label("General", systemImage: "gearshape")
			}
			CloudKitSettingsView().tabItem {
				Label("iCloud", systemImage: "arrow.triangle.2.circlepath.icloud.fill")
			}
		})
		.frame(width: 375, height: 150)
		.padding()
	}
	
	private struct GeneralSettingsView: View {
		@AppStorage("defaultName") private var defaultName: String = ""
		@AppStorage("defaultEmail") private var defaultEmail: String = ""
		
		var body: some View {
			Form {
				Section("Default Info") {
					Text("These will be applied to the 'Registered To' fields for any new licenses you add.")
						.font(.caption)
					TextField("Name", text: $defaultName)
					TextField("Email", text: $defaultEmail)
				}
			}
		}
	}
	
	private struct CloudKitSettingsView: View {
		@State var iCloudStatus: String = ""
		
		var body: some View {
			VStack {
				Text(iCloudStatus)
			}
		}
	}
}
