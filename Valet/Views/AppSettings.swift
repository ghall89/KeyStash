import LocalAuthentication
import SwiftUI

struct AppSettings: View {
	var body: some View {
		TabView(content: {
			GeneralSettings().tabItem {
				Label("General", systemImage: "gearshape")
			}
//			SecuritySettings().tabItem {
//				Label("Security", systemImage: "lock.open")
//			}
			CloudKitSettings().tabItem {
				Label("iCloud", systemImage: "arrow.triangle.2.circlepath.icloud.fill")
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
			Section("Default Info") {
				Text("These will be applied to the 'Registered To' fields for any new licenses you add.")
					.font(.caption)
				TextField("Name", text: $defaultName)
				TextField("Email", text: $defaultEmail)
			}
		}
	}
}

// struct SecuritySettings: View {
//	@EnvironmentObject var authentication: Authentication
//
//	var body: some View {
//		Form {
//			Toggle(isOn: $authentication.lockApp, label: {
//				Text("Lock Data")
//			})
//			.toggleStyle(.switch)
//		}
//		.onChange(of: authentication.lockApp, {
//			authenticateUser(reason: "change security settings") { result in
//				switch result {
//					case .success(let success):
//						saveSettingToKeychain(value: authentication.lockApp)
//						print("Authentication success: \(success)")
//					case .failure(let error):
//						authentication.lockApp.toggle()
//						print("Authentication failed with error: \(error)")
//				}
//			}
//		})
//	}
// }

struct CloudKitSettings: View {
	@State var iCloudStatus: String = ""

	var body: some View {
		VStack {
			Text(iCloudStatus)
		}
	}
}
