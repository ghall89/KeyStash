import SwiftUI

struct AttachmentRow: View {
	var license: License

	init(_ license: License) {
		self.license = license
	}

	var body: some View {
		VStack {
			if license.attachmentPath != nil {
				HStack(alignment: .top) {
					InfoButton(
						label: "Attachment",
						value: license.attachmentPath?.lastPathComponent ?? "",
						onClick: downloadAttachment
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
