import LocalAuthentication
import SwiftUI

struct AppSettingsView: View {
	@EnvironmentObject private var appState: AppState
	let databaseManager: DatabaseManager

	private let csv = LicenseCSVService()
	var licenses: [License]

	var body: some View {
		Form {
			Section("Default Info") {
				Text("These will be applied to the 'Registered To' and 'Email' fields for any new licenses you add.")
				TextField("Name", text: $appState.defaultName)
				TextField("Email", text: $appState.defaultEmail)
			}

			Section {
				HStack {
					Button(
						"Backup to CSV",
						systemImage: "arrow.down.circle",
						action: {
							csv.exportCSV(licenses: licenses)
						}
					)
					.frame(maxWidth: .infinity)
					Button(
						"Restore from CSV",
						systemImage: "arrow.up.circle",
						action: {
							Task {
								await csv.importCSV(refetch: databaseManager.fetchData)
							}
						}
					)
					.frame(maxWidth: .infinity)
				}
			}
		}
		.formStyle(.grouped)
	}
}
