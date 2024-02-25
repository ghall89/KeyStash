import GRDB
import SwiftUI

struct AttachmentRow: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var viewModes: ViewModes
	var license: License
	
	let label = "Attachment"
	
	var body: some View {
		VStack {
//			if viewModes.editMode == true {
//				if let attachment = license.attachmentPath {
//					HStack {
//						Button(action: {
//							showDeleteAlert.toggle()
//						}, label: {
//							Image(systemName: "xmark.circle.fill")
//								.foregroundStyle(.red)
//						})
//						.buttonStyle(.plain)
//
//						VStack(alignment: .leading) {
//							Text(label)
//								.font(.caption)
//							Text(attachment.lastPathComponent)
//								.fontDesign(.monospaced)
//						}
//					}
//					.confirmationDialog(
//						"Are you sure you want to remove this attachment? The file will be moved to your computer's Trash.",
//						isPresented: $showDeleteAlert,
//						actions: {
//							Button(action: {
//								showDeleteAlert.toggle()
//							}, label: {
//								Text("Cancel")
//							})
//							.keyboardShortcut(.defaultAction)
//							Button(action: {
//								removeAttachment()
//								showDeleteAlert.toggle()
//							}, label: {
//								Text("Delete")
//							})
//						})
//				} else {
//					Button(action: handleAttachment, label: {
//						Label("Add Attachment", systemImage: "paperclip")
//					})
//				}
//			} else {
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
