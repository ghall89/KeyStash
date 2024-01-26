import Foundation
import GRDB

func fetchAttachment(_ attachments: [Attachment], id: String) throws -> Attachment? {
	if let attachment = attachments.first(where: { $0.id == id }) {
		return attachment
	} else {
		return nil
	}
}


