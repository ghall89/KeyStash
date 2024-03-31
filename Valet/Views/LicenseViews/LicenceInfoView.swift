import AlertToast
import MarkdownUI
import SwiftUI

struct LicenceInfoView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var formState: EditFormState
	var license: License
	
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
					
					DateRowView(
						value: license.expirationDt,
						label: "Expiration Date"
					)
					
					AttachmentRowView(license: license)
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
	
	var body: some View {
		HStack(alignment: .top) {
			if value.count > 0 {
				Button(action: copyAction, label: {
					Image(systemName: "doc.on.doc.fill")
						.foregroundStyle(.accent)
						.contentTransition(.symbolEffect(.replace.downUp.byLayer))
				})
				.frame(width: 12)
				.buttonStyle(.plain)
				
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					Text(value)
				}
				.contextMenu {
					Button("Copy", action: copyAction)
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
	}
	
	private func copyAction() {
		stringToClipboard(value: value)
		showToast.toggle()
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
		.padding(.leading, 20)
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
	
	let label = "Attachment"
	
	var body: some View {
		VStack {
			if license.attachmentPath != nil {
				HStack(alignment: .top) {
					Button(action: {
						if let downloadableFile = license.attachmentPath {
							exportAttachment(file: downloadableFile)
						}
					}, label: {
						Image(systemName: "arrow.down.circle.fill")
							.foregroundStyle(.accent)
					})
					.buttonStyle(.plain)
					VStack(alignment: .leading) {
						Text(label)
							.font(.caption)
						Text(license.attachmentPath?.lastPathComponent ?? "")
							.fontDesign(.monospaced)
					}
				}
			}
		}
	}
}
