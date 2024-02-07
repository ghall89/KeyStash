import Foundation
import AppKit

func exportAttachment(file: URL) {
	let savePanel = NSSavePanel()
	let fileManager = FileManager.default
	savePanel.nameFieldStringValue = file.lastPathComponent
	
	if savePanel.runModal() == .OK {
		print(file.path)
		do {
			if let destinationPath = savePanel.url {
				try fileManager.copyItem(
					at: file,
					to: destinationPath
				)
			}
		} catch {
			print("Error: \(error.localizedDescription)")
		}
	}
}
