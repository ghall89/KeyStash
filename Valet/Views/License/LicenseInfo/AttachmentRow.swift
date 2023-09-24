import SwiftUI
import SwiftData

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
