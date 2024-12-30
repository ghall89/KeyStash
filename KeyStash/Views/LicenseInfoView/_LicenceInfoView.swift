import SwiftUI

struct LicenceInfoView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var formState: EditFormState
	
	@State private var license: License

	init(_ license: License) {
		self.license = license
	}

	var body: some View {
		ScrollView {
			VStack {
				LicenseHeader(license)
				LicenseDetails(license)
			}
		}
		.onChange(of: databaseManager.licenses, {
			let updatedLicense = databaseManager.licenses.first { $0.id == license.id }
			if let updatedLicense {
				license = updatedLicense
			}
		})
		.frame(maxWidth: .infinity)
		.environmentObject(formState)
		.toolbar {
			ToolbarItem {
				Spacer()
			}
			ToolbarItem(placement: .cancellationAction) {
				EditButton(license)
			}
		}
		.sheet(isPresented: $appState.showEditAppSheet) {
			EditLicenseView(isPresented: $appState.showEditAppSheet, license: license)
		}
	}
}
