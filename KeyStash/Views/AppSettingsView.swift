import LocalAuthentication
import SwiftUI

struct AppSettingsView: View {
	@AppStorage("defaultName") private var defaultName: String = ""
	@AppStorage("defaultEmail") private var defaultEmail: String = ""
	@AppStorage("requireUserAuth") private var requireUserAuth: Bool = false
	@AppStorage("requireAuthAfter") private var requireAuthAfter: MinutesUntilLocked = .fiveMinutes

	var body: some View {
		Form {
			Section("Default Info") {
				Text("These will be applied to the 'Registered To' and 'Email' fields for any new licenses you add.")
				TextField("Name", text: $defaultName)
				TextField("Email", text: $defaultEmail)
			}
			Section("Security") {
				Toggle("Require password/Touch ID", isOn: $requireUserAuth)
				if requireUserAuth == true {
					Picker("Require authentication after: ", selection: $requireAuthAfter, content: {
						ForEach(MinutesUntilLocked.allCases, id: \.self, content: { option in
							Text(option.rawValue).tag(option)
						})
					})
				}
			}
		}
		.formStyle(.grouped)
	}
}

enum MinutesUntilLocked: String, CaseIterable {
	case oneMinute = "1 Minute"
	case fiveMinutes = "5 Minutes"
	case tenMinutes = "10 Minutes"
}
