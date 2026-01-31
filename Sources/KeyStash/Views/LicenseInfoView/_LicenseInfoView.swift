import SwiftUI

struct LicenseInfoView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var formState: EditFormState

	@Binding var selectedLicense: License

	var body: some View {
		LicenseDetails(selectedLicense)
			.frame(maxWidth: .infinity)
			.environmentObject(formState)
			.toolbar {
				ToolbarItem {
					Spacer()
				}
				ToolbarItem(placement: .primaryAction) {
					EditButton(selectedLicense)
				}
			}
			.sheet(isPresented: $appState.showEditAppSheet) {
				EditLicenseView(isPresented: $appState.showEditAppSheet, license: selectedLicense)
			}
	}
}
