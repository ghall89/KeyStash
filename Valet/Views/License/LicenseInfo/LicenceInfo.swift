import AlertToast
import MarkdownUI
import SwiftUI

struct LicenceInfo: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var viewModes: ViewModes
	@EnvironmentObject var formState: EditFormState
	var license: License
	
	@State var showEditAppSheet: Bool = false
	@State private var showToast: Bool = false
	
	@AppStorage("disableAnimations") private var disableAnimations: Bool = false
	
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
						VStack(alignment: .leading) {
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
						Spacer()
					}
					.padding()
				}
				VStack(alignment: .leading, spacing: 12) {
					LicenseInfoRow(
						showToast: $showToast,
						value: license.registeredToName,
						label: "Registered To"
					)
					
					LicenseInfoRow(
						showToast: $showToast,
						value: license.registeredToEmail,
						label: "Email"
					)
					
					LicenseInfoRow(
						showToast: $showToast,
						value: license.licenseKey,
						label: "License Key"
					)
					
					DateInfoRow(
						value: license.expirationDt,
						label: "Expiration Date"
					)
					
					AttachmentRow(license: license)
					Divider()
					Text("Notes")
						.font(.caption)
					Markdown(license.notes)
				}
				.frame(maxWidth: .infinity)
				.padding()
			}
		}
		.frame(maxWidth: .infinity)
		.environmentObject(formState)
		.toast(isPresenting: $showToast) {
			AlertToast(type: .regular, title: "Copied to Clipboard")
		}
		.toolbar {
			ToolbarItem {
				Spacer()
			}
			ToolbarItem(placement: .primaryAction) {
				Button(action: {
					if showEditAppSheet == false {
						initFormState()
					}
					showEditAppSheet.toggle()
				}, label: {
					Image(systemName: "square.and.pencil")
				})
				.help("Edit")
			}
		}
		.sheet(isPresented: $showEditAppSheet) {
			EditAppView(isPresented: $showEditAppSheet, license: license)
		}
	}
	
	private func initFormState() {
		formState.softwareName = license.softwareName
		formState.urlString = license.downloadUrlString
		formState.registeredToName = license.registeredToName
		formState.registeredToEmail = license.registeredToEmail
		formState.licenseKey = license.licenseKey
		formState.expirationDt = license.expirationDt
		formState.notes = license.notes
	}
}
