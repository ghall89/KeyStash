import LocalAuthentication
import SQLiteData
import SwiftUI

struct AppSettingsView: View {
	@EnvironmentObject private var appState: AppState
	@Dependency(\.defaultSyncEngine) private var syncEngine
	@AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled: Bool = true

	let databaseManager: DatabaseManager

	private let csv = LicenseCSVService()
	var licenses: [License]

	var body: some View {
		Form {
			Section("iCloud") {
				Toggle("Sync with iCloud", isOn: $iCloudSyncEnabled)
					.onChange(of: iCloudSyncEnabled) { _, enabled in
						Task {
							if enabled {
								try? await syncEngine.start()
							} else {
								syncEngine.stop()
							}
						}
					}
				HStack(spacing: 6) {
					if !iCloudSyncEnabled {
						Label("Sync disabled", systemImage: "icloud.slash")
					} else if syncEngine.isSynchronizing {
						ProgressView()
							.controlSize(.small)
						Text("Syncing\u{2026}")
					} else if syncEngine.isRunning {
						Label("Up to date", systemImage: "checkmark.icloud")
					}
				}
				.font(.callout)
				.foregroundStyle(.secondary)
			}
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
