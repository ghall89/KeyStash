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
				.confirmationDialog("Are you sure you want to remove this attachment? Data will be lost.", isPresented: $showDeleteAlert, actions: {
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
			if license.attachmentId != nil {
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
				.onChange(of: license.id, initial: true) {
					fetchAttachment()
				}
			}
		}
	}
	
	private func handleAttachment() {
		if let fileFromDisk = getAttachment() {
			do {
				var updatedLicense = license
				updatedLicense.attachmentId = fileFromDisk.id
				try addAttachmentToLicense(databaseManager.dbQueue, data: updatedLicense, attachment: fileFromDisk)
				file = fileFromDisk
			} catch {
				print("Error: \(error)")
			}
		}
	}
	
	private func removeAttachment() {
		if let attachmentObj = file {
			do {
				try deleteAttachment(databaseManager.dbQueue, attachment: attachmentObj)
			} catch {
				print("Error: \(error)")
			}
		}
	}
	
	private func fetchAttachment() {
		if let attachmentId = license.attachmentId {
			do {
				try databaseManager.dbQueue.read { db in
					print(db)
					let attachment = try Attachment.find(db, key: ["id": attachmentId])
					print(attachment)
					file = attachment
				}
			} catch {
				print("Error: \(error)")
			}
		}
	}
}
