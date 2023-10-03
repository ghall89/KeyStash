import SwiftUI

struct AppSettings: View {
	
	var body: some View {
		TabView(content: {
			GeneralSettings().tabItem {
				Label("General", systemImage: "gearshape")
			}
			SecuritySettings().tabItem {
				Label("Security", systemImage: "lock.open")
			}
			AppearanceSettings().tabItem {
				Label("Appearance", systemImage: "paintbrush")
			}
		})
		.frame(width: 375, height: 150)
		.padding()
	}
}

struct GeneralSettings: View {
	@AppStorage("defaultName") private var defaultName: String = ""
	@AppStorage("defaultEmail") private var defaultEmail: String = ""

	
	var body: some View {
		Form {
			Section ("Default Info") {
				Text("These will be applied to the 'Registered To' fields for any new licenses you add.")
					.font(.caption)
				TextField("Name", text: $defaultName)
				TextField("Email", text: $defaultEmail)
			}
		
		}
	}
}

struct SecuritySettings: View {
	@AppStorage("lockApp") private var lockApp: Bool = false
	
	var body: some View {
		Form {
			Text("🔨 Coming Soon...")
//			Toggle(isOn: $lockApp, label: {
//				Text("Lock Data")
//			})
//			.toggleStyle(.switch)
		}
	}
}

struct AppearanceSettings: View {
	@AppStorage("compactList") private var compactList: Bool = false
	@AppStorage("disableAnimations") private var disableAnimations: Bool = false
	
	var body: some View {
		Form {
			Section {
				Toggle("Compact List", isOn: $compactList)
				Text("Hide icons, and display lists in a more compact form.")
					.font(.caption)
				Toggle("Disable Animations", isOn: $disableAnimations)
			}
		}
	}
}
