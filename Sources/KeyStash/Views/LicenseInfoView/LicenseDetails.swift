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
				if license.expirationDt != nil {
					DateRow(
						"Expires",
						value: license.expirationDt
					)
				}
			}
			Section {
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
			if !license.notes.isEmpty {
				Section("Notes") {
					Text(license.notes)
				}
			}
		}
		.formStyle(.grouped)
	}
}
