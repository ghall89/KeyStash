import SwiftUI
import SwiftData
import MarkdownUI
import AlertToast

struct LicenceInfo: View {
	@EnvironmentObject var viewModes: ViewModes
	@Bindable var license: License
	
	@State private var showToast: Bool = false
	@State private var formState: FormState = FormState(
		softwareName: "",
		urlString: "",
		registeredToName: "",
		registeredToEmail: "",
		licenseKey: "",
		notes: ""
	)
	
	var body: some View {
		ScrollView {
			VStack {
				ZStack {
					Rectangle()
						.fill(.regularMaterial)
					HStack {
						Image(nsImage: license.iconNSImage)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 75)
						VStack {
							if viewModes.editMode == true {
								TextField("Some Cool App", text: $formState.softwareName)
									.textFieldStyle(RoundedBorderTextFieldStyle())
								TextField("https://sampleapp.com/download", text: $formState.urlString)
									.textFieldStyle(RoundedBorderTextFieldStyle())
							} else {
								Text(license.softwareName)
									.font(.title)
									.multilineTextAlignment(.leading)
								if let url = license.downloadUrl {
									Link(destination: url, label: {
										if isDownloadLink(url: url) {
											Label("Download", systemImage: "arrow.down.circle")
										} else {
											Label("Website", systemImage: "safari")
										}
									})
									.buttonStyle(.borderedProminent)
								}
							}
						}
						Spacer()
					}
					.padding()
				}
				VStack(alignment: .leading, spacing: 12) {
					
					LicenseInfoRow(
						showToast: $showToast,
						value: $license.registeredToName,
						formValue: $formState.registeredToName,
						label: "Registered To"
					)
					
					LicenseInfoRow(
						showToast: $showToast,
						value: $license.registeredToEmail,
						formValue: $formState.registeredToEmail,
						label: "Email"
					)
					
					LicenseInfoRow(
						showToast: $showToast,
						value: $license.licenseKey,
						formValue: $formState.licenseKey,
						label: "License Key")
					
					AttachmentRow(file: $license.attachment)
					Divider()
					Text("Notes")
						.font(.caption)
					if viewModes.editMode == true {
						TextEditor(text: $formState.notes)
							.frame(minHeight: 100)
					} else {
						Markdown(license.notes)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
			}
			.animation(.easeInOut, value: viewModes.editMode)
		}
		.frame(maxWidth: .infinity)
		.toast(isPresenting: $showToast) {
			AlertToast(type: .complete(.accent), title: "Copied to Clipboard")
		}
		.toolbar {
			ToolbarItem {
				Spacer()
			}
			if viewModes.editMode == true {
				ToolbarItem {
					Button(action: {
						saveFormState()
						viewModes.editMode.toggle()
					}, label: {
						Image(systemName: "checkmark.circle")
					})
					.disabled(!isEdited())
					.keyboardShortcut(KeyEquivalent("s"))
				}
			}
			ToolbarItem {
				Button(action: {
					if viewModes.editMode == false {
						initFormState()
					}
					viewModes.editMode.toggle()
				}, label: {
					Image(systemName: viewModes.editMode == true ? "xmark.circle" : "square.and.pencil")
				})
			}
		}
	}
	
	private func initFormState() {
		formState.softwareName = license.softwareName
		formState.urlString = license.downloadUrlString
		formState.registeredToName = license.registeredToName
		formState.registeredToEmail = license.registeredToEmail
		formState.licenseKey = license.licenseKey
		formState.notes = license.notes
	}
	
	private func saveFormState() {
		license.softwareName = formState.softwareName
		license.downloadUrlString = formState.urlString
		license.registeredToName = formState.registeredToName
		license.registeredToEmail = formState.registeredToEmail
		license.licenseKey = formState.licenseKey
		license.notes = formState.notes
		license.updatedDate = Date()
	}
	
	private func isEdited() -> Bool {
		if formState.softwareName == license.softwareName &&
				formState.urlString == license.downloadUrlString &&
				formState.registeredToName == license.registeredToName &&
				formState.registeredToEmail == license.registeredToEmail &&
				formState.licenseKey == license.licenseKey &&
				formState.notes == license.notes {
			return false
		}
		
		return true
	}
	
	private struct FormState: Equatable {
		var softwareName: String
		var urlString: String
		var registeredToName: String
		var registeredToEmail: String
		var licenseKey: String
		var notes: String
	}
}
