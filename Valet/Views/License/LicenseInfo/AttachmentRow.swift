import SwiftUI
import GRDB

struct AttachmentRow: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var viewModes: ViewModes
	var license: License
	
	@State var file: Attachment? = nil
	@State private var showDeleteAlert: Bool = false
	let label = "Attachment"
	
	var body: some View {
		VStack {
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
			} else {
				if file != nil {
					HStack(alignment: .top) {
						Button(action: {
							if let downloadableFile = file {
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
							Text(file?.filename ?? "")
								.fontDesign(.monospaced)
						}
					}
				}
			}
		}
		.onChange(of: license.id, initial: true) {
			setAttachment()
		}
	}
	
	private func handleAttachment() {
		if let fileFromDisk = getAttachment() {
			do {
				var updatedLicense = license
				updatedLicense.attachmentId = fileFromDisk.id
				try addAttachmentToLicense(databaseManager.dbQueue, data: updatedLicense, attachment: fileFromDisk)
				databaseManager.fetchData()
				file = fileFromDisk
			} catch {
				print("Error: \(error)")
			}
		}
	}
	
	private func removeAttachment() {
		if let attachmentObj = file {
			do {
				try deleteAttachment(databaseManager.dbQueue, attachmentId: attachmentObj.id)
				databaseManager.fetchData()
				file = nil
			} catch {
				print("Error: \(error)")
			}
		}
	}
	
	private func setAttachment() {
		do {
			if let attachmentId = license.attachmentId {
				let attachmentById = try fetchAttachment(
					databaseManager.attachments,
					id: attachmentId
				)
			}
		} catch {
			print("Error: \(error)")
		}
	}
}
