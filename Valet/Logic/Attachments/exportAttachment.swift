import Foundation
import AppKit

func exportAttachment(file: Attachment) {
	let savePanel = NSSavePanel()
	savePanel.nameFieldStringValue = file.filename
	
	if savePanel.runModal() == .OK {
		let path = savePanel.url?.path
		do {
			try file.data.write(to: URL(filePath: path!))
		} catch {
			print("Error: \(error.localizedDescription)")
		}
	}
}
