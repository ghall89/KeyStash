import AlertToast
import SwiftUI

struct LicenceInfoView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var formState: EditFormState
	var license: License

	@State private var showToast: Bool = false

	init(_ license: License) {
		self.license = license
	}

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
							if let version = license.version {
								if !version.isEmpty {
									Text(version)
								}
							}
							if let purchaseDt = license.purchaseDt {
								Text("Purchased \(purchaseDt.formatted(date: .abbreviated, time: .omitted))")
							}
						}
						Spacer()
						if let url = license.downloadUrl {
							Link(destination: url, label: {
								if isDownloadLink(url: url) {
									Label("Download", systemImage: "arrow.down.circle")
								} else {
									Label("Website", systemImage: "safari")
								}
							})
							.buttonStyle(.borderless)
							.foregroundStyle(Color.accent)
						}
					}
					.padding()
				}
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
					AttachmentRow()
					Divider()
					Text("Notes")
						.font(.caption)
					Text(license.notes)
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
			ToolbarItem(placement: .cancellationAction) {
				Button(action: {
					if appState.showEditAppSheet == false {
						initFormState()
					}
					appState.showEditAppSheet.toggle()
				}, label: {
					Image(systemName: "square.and.pencil")
				})
				.help("Edit")
			}
		}
		.sheet(isPresented: $appState.showEditAppSheet) {
			EditLicenseView(isPresented: $appState.showEditAppSheet, license: license)
		}
	}

	private func initFormState() {
		formState.icon = nil
		formState.softwareName = license.softwareName
		formState.urlString = license.downloadUrlString
		formState.version = license.version ?? ""
		formState.registeredToName = license.registeredToName
		formState.registeredToEmail = license.registeredToEmail
		formState.licenseKey = license.licenseKey
		if license.purchaseDt != nil {
			formState.purchaseDt = license.purchaseDt
		}
		if license.expirationDt != nil {
			formState.addExpiration = true
		}
		formState.expirationDt = license.expirationDt
		formState.notes = license.notes
	}

	private func InfoRow(_ label: String, value: String) -> some View {
		return HStack(alignment: .top) {
			if !value.isEmpty {
				InfoButton(
					label: label,
					value: value,
					onClick: {
						copyAction(value)
					},
					icon: SFSymbol.document
				)
				.contextMenu {
					Button("Copy \"\(value)\"", action: {
						copyAction(value)
					})
				}
				Spacer()
			}
		}
	}

	private func DateRow(_ label: String, value: Date?) -> some View {
		let valueString = {
			let now = Date()
			if let dateToCompare = value {
				let dateString = value?.formatted(date: .complete, time: .omitted) ?? ""
				let daysLeft = differenceInDays(date1: now, date2: dateToCompare)
				let parensString = isPast() ? "Expired" : "\(daysLeft) Days Left"

				return "\(dateString) (\(parensString))"
			}

			return ""
		}

		func isPast() -> Bool {
			let now = Date()

			if let dateToCompare = value {
				return dateToCompare < now
			}

			return false
		}

		return HStack(alignment: .top) {
			if value != nil {
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					Text(valueString())
						.foregroundStyle(isPast() ? Color.red : Color.primary)
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
		.padding(.leading, 30)
	}

	private func AttachmentRow() -> some View {
		return VStack {
			if license.attachmentPath != nil {
				HStack(alignment: .top) {
					InfoButton(
						label: "Attachment",
						value: license.attachmentPath?.lastPathComponent ?? "",
						onClick: downloadAttachment,
						icon: SFSymbol.arrowDown
					)
					.monospaced()
				}
			}
		}
	}

	private func downloadAttachment() {
		if let downloadableFile = license.attachmentPath {
			exportAttachment(file: downloadableFile)
		}
	}

	private func copyAction(_ value: String) {
		stringToClipboard(value: value)
		showToast = true
	}
}
