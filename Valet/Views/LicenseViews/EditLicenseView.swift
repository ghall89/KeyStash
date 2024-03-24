import SwiftUI

struct EditLicenseView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var formState: EditFormState
	@EnvironmentObject var appState: AppState
	
	@Binding var isPresented: Bool
	
	var license: License

	@State var selectedDate: Date = .init()
	@State private var showDeleteAlert: Bool = false

	var body: some View {
		Form {
			Section {
				TextField("Name", text: $formState.softwareName)
				TextField("URL", text: $formState.urlString)
			}
			Section {
				TextField("Registered To", text: $formState.registeredToName)
				TextField("Email", text: $formState.registeredToEmail)
				TextField("License Key", text: $formState.licenseKey)
			}
			Section {
				Toggle(isOn: $formState.addExpiration, label: {
					Text("License Expires")
				})
				if formState.addExpiration {
					DatePicker(
						"Expiration Date",
						selection: $selectedDate,
						displayedComponents: [.date])
				}
			}
			Section {
				if let attachment = license.attachmentPath {
					HStack {
						Button(action: {
							showDeleteAlert.toggle()
						}, label: {
							Image(systemName: "xmark.circle.fill")
								.foregroundStyle(.red)
						})
						.buttonStyle(.plain)
				
						VStack(alignment: .leading) {
							Text(attachment.lastPathComponent)
								.fontDesign(.monospaced)
						}
					}
					.confirmationDialog(
						"Are you sure you want to remove this attachment? The file will be moved to your computer's Trash.",
						isPresented: $showDeleteAlert,
						actions: {
							Button(action: {
								showDeleteAlert.toggle()
							}, label: {
								Text("Cancel")
							})
							.keyboardShortcut(.defaultAction)
							Button(action: {
								removeAttachment()
								showDeleteAlert.toggle()
							}, label: {
								Text("Delete")
							})
						})
				} else {
					Button(action: handleAttachment, label: {
						Label("Add Attachment", systemImage: "paperclip")
					})
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
				Button(
					action: {
						isPresented.toggle()
					},
					label: {
						Text("Cancel")
					})
			}
			ToolbarItem(placement: .primaryAction) {
				Button(
					action: {
						saveFormState()
						isPresented.toggle()
					},
					label: {
						Text("Save")
					})
			}
		}
		.onChange(of: selectedDate) {
			formState.expirationDt = selectedDate
		}
		.onAppear {
			if license.expirationDt != nil {
				selectedDate = license.expirationDt!
			}
		}
	}
	
	private func saveFormState() {
		do {
			var updatedLicense = license
			updatedLicense.softwareName = formState.softwareName
			updatedLicense.downloadUrlString = formState.urlString
			updatedLicense.registeredToName = formState.registeredToName
			updatedLicense.registeredToEmail = formState.registeredToEmail
			updatedLicense.licenseKey = formState.licenseKey
			if formState.addExpiration {
				updatedLicense.expirationDt = formState.expirationDt
			} else {
				updatedLicense.expirationDt = nil
			}
			updatedLicense.notes = formState.notes
			try updateLicense(databaseManager.dbQueue, data: updatedLicense)
			databaseManager.fetchData()
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
	
	private func handleAttachment() {
		if let fileFromDisk = getAttachment() {
			do {
				var updatedLicense = license
				updatedLicense.attachmentPath = fileFromDisk
				try addAttachmentToLicense(databaseManager.dbQueue, data: updatedLicense, attachment: fileFromDisk)
				databaseManager.fetchData()
			} catch {
				logger.error("ERROR: \(error)")
			}
		}
	}
	
	private func removeAttachment() {
		do {
			try deleteAttachment(databaseManager.dbQueue, license: license)
			databaseManager.fetchData()
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
}
