import Foundation
import AppKit

/* display save dialog and copy given file from application container
to user-selected directory */

func exportAttachment(file: URL) {
	let savePanel = NSSavePanel()
	let fileManager = FileManager.default
	savePanel.nameFieldStringValue = file.lastPathComponent
	
	if savePanel.runModal() == .OK {
		logger.log("\(file.path)")
		do {
			if let destinationPath = savePanel.url {
				try fileManager.copyItem(
					at: file,
					to: destinationPath
				)
			}
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
}
