import Foundation
import AppKit

func addAttachment() -> Attachment? {
	let openPanel = NSOpenPanel()
	
	openPanel.allowsMultipleSelection = false
	openPanel.canChooseFiles = true
	openPanel.canChooseDirectories = false
	
	if openPanel.runModal() == .OK {
		do {
			let path = openPanel.url!.path
			let attachment = try Data(NSData(contentsOfFile: path))
			return Attachment(filename: openPanel.url!.lastPathComponent, data: attachment)
		} catch {
			print("Error: \(error.localizedDescription)")
			return nil
		}
	}
	
	
	return nil
}
