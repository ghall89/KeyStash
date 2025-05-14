import SwiftUI

struct LicenseDetails: View {
	var license: License

	init(_ license: License) {
		self.license = license
	}

	var body: some View {
		Form {
			Section {
				LicenseHeader(license)
				DateRow(
					"Expires",
					value: license.expirationDt
				)
				InfoRow(
					"Registered To",
					value: license.registeredToName
				)
				InfoRow(
					"Email",
					value: license.registeredToEmail
				)
				InfoRow(
					"License Key",
					value: license.licenseKey
				)
			}
			Section("Notes") {
				Text(license.notes)
			}
		}
		.formStyle(.grouped)
	}
}
