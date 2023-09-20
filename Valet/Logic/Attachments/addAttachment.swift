import Foundation
import AppKit

func addAttachment() -> Attachment? {
	let openPanel = NSOpenPanel()
	
	openPanel.allowsMultipleSelection = false
	openPanel.allowedContentTypes = [.data]
	
	if openPanel.runModal() == .OK {
		let path = openPanel.url?.path
		
		if let url = URL(string: path!) {
			print(url.lastPathComponent)
			do {
				let attachment = try Data(contentsOf: url)
				return Attachment(filename: url.lastPathComponent, data: attachment)
			} catch {
				print("Error: \(error.localizedDescription)")
				return nil
			}
		}
	}
	
	return nil
}
