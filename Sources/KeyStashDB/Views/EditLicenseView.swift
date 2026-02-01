import KeyStashModels
import SwiftUI

struct EditLicenseView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var formState: EditFormState

	@Binding var isPresented: Bool

	@State private var selectedPurchaseDate = Date()
	@State private var selectedExpDate = Date()
	@State private var showDeleteAlert = false

	var license: License

	let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	var body: some View {
		Form {
			Section {
				HStack {
					Image(nsImage: ((formState.icon != nil) ? NSImage(data: formState.icon!) : license.iconNSImage)!)
						.resizable()
						.frame(width: 45, height: 45)
					Spacer()
					Button("Change Icon") {
						if let newIcon = getCustomIcon() {
							formState.icon = newIcon
						}
					}
				}
				TextField("Name", text: $formState.softwareName)
				TextField("URL", text: $formState.urlString)
				TextField("Version", text: $formState.version)
			}
			Section {
				TextField("Registered To", text: $formState.registeredToName)
				TextField("Email", text: $formState.registeredToEmail)
				TextField("License Key", text: $formState.licenseKey)
				DatePicker(
					"Purchase Date",
					selection: $selectedPurchaseDate,
					displayedComponents: [.date]
				)
			}
			Section {
				Toggle(isOn: $formState.addExpiration, label: {
					Text("License Expires")
				})
				if formState.addExpiration {
					DatePicker(
						"Expiration Date",
						selection: $selectedExpDate,
						displayedComponents: [.date]
					)
				}
			}

			Section("Notes") {
				TextEditor(text: $formState.notes)
			}
		}
		.formStyle(.grouped)
		.frame(width: 400)
		.padding()
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel") {
					isPresented.toggle()
				}
			}
			ToolbarItem(placement: .primaryAction) {
				Button("Save") {
					saveFormState()
					isPresented.toggle()
				}
			}
		}
		.onChange(of: selectedPurchaseDate) {
			formState.purchaseDt = selectedPurchaseDate
		}
		.onChange(of: selectedExpDate) {
			formState.expirationDt = selectedExpDate
		}
		.onAppear {
			if license.expirationDt != nil {
				selectedExpDate = license.expirationDt!
			}
		}
	}

	private func saveFormState() {
		var updatedLicense = license
		updatedLicense.icon = formState.icon != nil ? formState.icon : license.icon
		updatedLicense.softwareName = formState.softwareName
		updatedLicense.version = formState.version
		updatedLicense.downloadURLString = formState.urlString
		updatedLicense.registeredToName = formState.registeredToName
		updatedLicense.registeredToEmail = formState.registeredToEmail
		updatedLicense.licenseKey = formState.licenseKey
		updatedLicense.purchaseDt = formState.purchaseDt
		if formState.addExpiration {
			updatedLicense.expirationDt = formState.expirationDt
		} else {
			updatedLicense.expirationDt = nil
		}
		updatedLicense.notes = formState.notes
		databaseManager.dbService.updateLicense(data: updatedLicense)
		databaseManager.fetchData()
	}
}
