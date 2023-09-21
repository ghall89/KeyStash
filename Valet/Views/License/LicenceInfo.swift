import SwiftUI
import AppKit
import SwiftData
import MarkdownUI
import AlertToast

struct LicenceInfo: View {
	@EnvironmentObject var viewModes: ViewModes
	@State var showToast: Bool = false
	@Bindable var license: License
	
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
							Text(license.softwareName)
								.font(.title)
								.multilineTextAlignment(.leading)
							if viewModes.editMode == true {
								TextField("URL", text: $license.downloadUrlString)
							} else {
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
					LicenseInfoRow(showToast: $showToast, value: $license.registeredToName, label: "Registered To")
					LicenseInfoRow(showToast: $showToast, value: $license.registeredToEmail, label: "Email")
					LicenseInfoRow(showToast: $showToast, value: $license.licenseKey, label: "License Key")
					AttachmentRow(file: $license.attachment)
					Divider()
					Text("Notes")
						.font(.caption)
					if viewModes.editMode == true {
						TextEditor(text: $license.notes)
							.frame(minHeight: 100)
					} else {
						Markdown(license.notes)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
			}
		}
		.frame(maxWidth: .infinity)
		.toast(isPresenting: $showToast) {
			AlertToast(type: .complete(.accent), title: "Copied to Clipboard")
		}
		.onChange(of: license, {
			if viewModes.editMode == true {
				viewModes.editMode.toggle()
			}
		})
		.onAppear {
			if viewModes.editMode == true {
				viewModes.editMode.toggle()
			}
		}
		.toolbar {
			ToolbarItem {
				Spacer()
			}
			ToolbarItem {
				Button(action: {
					viewModes.editMode.toggle()
				}, label: {
					Image(systemName: viewModes.editMode == true ? "checkmark.circle.fill" : "pencil")
				})
			}
		}
	}
	
	private func isDownloadLink(url: URL) -> Bool {
		let pathExtension = url.pathExtension.lowercased()
		let downloadExtensions: [String] = ["zip", "dmg", "app"]
		
		return downloadExtensions.contains(pathExtension)
	}
}

struct LicenseInfoRow: View {
	@EnvironmentObject var viewModes: ViewModes
	@Binding var showToast: Bool
	@Binding var value: String
	var label: String
	
	var body: some View {
		HStack(alignment: .top) {
			if value.count > 0 || viewModes.editMode == true {
				Button(action: {
					copyToClipboard(value: value)
				}, label: {
					Image(systemName: "doc.on.doc.fill")
						.foregroundStyle(.accent)
				})
				.buttonStyle(.plain)
				.disabled(viewModes.editMode)
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					if viewModes.editMode == true {
						TextField(getPlaceholderText(), text: $value)
							.textFieldStyle(.plain)
							.lineLimit(label == "License Key" ? 10 : 1)
					} else {
						Text(value)
					}
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
	}
	
	private func getPlaceholderText() -> String {
		switch label {
			case "Registered To":
				return "Johnny Appleseed"
			case "Email":
				return "sample@email.com"
			case "License Key":
				return "XX-XXXX-XXXX-XXXX-XXXX"
			default:
				return "Lorem ipsum..."
		}
	}
	
	private func copyToClipboard(value: String) {
		let clipboard = NSPasteboard.general
		clipboard.clearContents()
		clipboard.setString(value, forType: .string)
		if showToast == false {
			showToast.toggle()
		}
	}
}

struct AttachmentRow: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var files: [Attachment]
	@EnvironmentObject var viewModes: ViewModes
	@Binding var file: Attachment?
	
	@State var showDeleteAlert: Bool = false
	let label = "Attachment"
	
	var body: some View {
		if viewModes.editMode == true {
			if let attachment = file {
				HStack {
					Button(action: {
						showDeleteAlert.toggle()
					}, label: {
						Image(systemName: "xmark.circle.fill")
							.foregroundStyle(.red)
					})
					.buttonStyle(.plain)
					VStack(alignment: .leading) {
						Text(label)
							.font(.caption)
						Text(attachment.filename)
							.fontDesign(.monospaced)
					}
				}
				.alert("Are you sure you want to remove this attachment? Data will be lost.", isPresented: $showDeleteAlert, actions: {
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
		} else {
			if let attachment = file {
				HStack(alignment: .top) {
					Button(action: {
						exportAttachment(file: attachment)
					}, label: {
						Image(systemName: "arrow.down.circle.fill")
							.foregroundStyle(.accent)
					})
					.buttonStyle(.plain)
					VStack(alignment: .leading) {
						Text(label)
							.font(.caption)
						Text(attachment.filename)
							.fontDesign(.monospaced)
					}
				}
			}
		}
	}
	
	private func handleAttachment() {
		if let attachment = addAttachment() {
			file = attachment
		}
	}
	
	private func removeAttachment() {
		if let attachmentId = file?.id {
			let index = files.firstIndex(where: { $0.id == attachmentId })!
			file = nil
			modelContext.delete(files[index])
		}
	}
}
