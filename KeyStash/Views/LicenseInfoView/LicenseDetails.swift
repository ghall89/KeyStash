import SwiftUI

struct LicenseDetails: View {
	var license: License

	init(_ license: License) {
		self.license = license
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
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
			AttachmentRow(license)
			Divider()
			Text("Notes")
				.font(.caption)
			Text(license.notes)
		}
		.frame(maxWidth: .infinity)
		.padding()
	}
}
