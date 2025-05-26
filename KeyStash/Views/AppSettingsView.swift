import LocalAuthentication
import SwiftUI

struct AppSettingsView: View {
	@EnvironmentObject private var settingsState: SettingsState

	var body: some View {
		Form {
			Section("Default Info") {
				Text("These will be applied to the 'Registered To' and 'Email' fields for any new licenses you add.")
				TextField("Name", text: $settingsState.defaultName)
				TextField("Email", text: $settingsState.defaultEmail)
			}
			Section("Security") {
				Toggle("Require password/Touch ID", isOn: $settingsState.requireUserAuth)
				if settingsState.requireUserAuth == true {
					Picker("Require authentication after: ", selection: $settingsState.requireAuthAfter, content: {
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
