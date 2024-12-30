import SwiftUI

struct EditButton: View {
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var formState: EditFormState
	var license: License
	
	init(_ license: License) {
		self.license = license
	}
	
	var body: some View {
		Button(action: {
			if appState.showEditAppSheet == false {
				initFormState()
			}
			appState.showEditAppSheet.toggle()
		}) {
			Image(systemName: "square.and.pencil")
		}
		.help("Edit")
	}
	
	private func initFormState() {
		formState.icon = nil
		formState.softwareName = license.softwareName
		formState.urlString = license.downloadUrlString
		formState.version = license.version ?? ""
		formState.registeredToName = license.registeredToName
		formState.registeredToEmail = license.registeredToEmail
		formState.licenseKey = license.licenseKey
		formState.purchaseDt = license.purchaseDt
		formState.addExpiration = license.expirationDt != nil
		formState.expirationDt = license.expirationDt
		formState.notes = license.notes
	}
}
