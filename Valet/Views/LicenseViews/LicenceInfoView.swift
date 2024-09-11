import AlertToast
import SwiftUI

struct LicenceInfoView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var formState: EditFormState
	var license: License

	@State private var showToast: Bool = false

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
							.buttonStyle(.borderedProminent)
						}
					}
					.padding()
				}
				VStack(alignment: .leading, spacing: 12) {
					DateRowView(
						value: license.expirationDt,
						label: "Expires"
					)
					InfoRowView(
						showToast: $showToast,
						value: license.registeredToName,
						label: "Registered To"
					)
					InfoRowView(
						showToast: $showToast,
						value: license.registeredToEmail,
						label: "Email"
					)
					InfoRowView(
						showToast: $showToast,
						value: license.licenseKey,
						label: "License Key"
					)
					AttachmentRowView(license: license)
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
			ToolbarItem(placement: .primaryAction) {
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
}

struct InfoRowView: View {
	@Binding var showToast: Bool
	var value: String
	var label: String
	
	@State var isHovering = false

	@State var isHovering = false

	var body: some View {
		HStack(alignment: .top) {
			if !value.isEmpty {
				InfoButton(
					label: label,
					value: value,
					onClick: copyAction,
					icon: SFSymbol.document
				)
				.contextMenu {
					Button("Copy \"\(value)\"", action: copyAction)
				}
				Spacer()
			}
		}
	}

	private func copyAction() {
		stringToClipboard(value: value)
		showToast = true
	}
}

struct DateRowView: View {
	var value: Date?
	var label: String

	var body: some View {
		HStack(alignment: .top) {
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

	private func valueString() -> String {
		let now = Date()
		if let dateToCompare = value {
			let dateString = value?.formatted(date: .complete, time: .omitted) ?? ""
			let daysLeft = differenceInDays(date1: now, date2: dateToCompare)
			let parensString = isPast() ? "Expired" : "\(daysLeft) Days Left"

			return "\(dateString) (\(parensString))"
		}

		return ""
	}

	private func differenceInDays(date1: Date, date2: Date) -> Int {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.day], from: date1, to: date2)
		return abs(components.day ?? 0)
	}

	private func isPast() -> Bool {
		let now = Date()

		if let dateToCompare = value {
			return dateToCompare < now
		}

		return false
	}
}

struct AttachmentRowView: View {
	var license: License

	var body: some View {
		VStack {
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
}
