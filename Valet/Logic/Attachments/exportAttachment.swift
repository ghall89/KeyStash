import Foundation
import AppKit

func exportAttachment(file: Attachment) {
	let savePanel = NSSavePanel()
	let fileManager = FileManager.default
	savePanel.nameFieldStringValue = file.filename
	
	if savePanel.runModal() == .OK {
		print(file.path)
		do {
			if let destinationPath = savePanel.url {
				try fileManager.copyItem(
					at: file.path,
					to: destinationPath
				)
			}
		} catch {
			print("Error: \(error.localizedDescription)")
		}
	}
}
