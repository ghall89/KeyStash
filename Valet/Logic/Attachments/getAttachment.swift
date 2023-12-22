import Foundation
import AppKit

func getAttachment() -> Attachment? {
	let openPanel = NSOpenPanel()
	let fileManager = FileManager.default
	
	openPanel.allowsMultipleSelection = false
	openPanel.canChooseFiles = true
	openPanel.canChooseDirectories = false
	
	if openPanel.runModal() == .OK {
		do {
			guard let sourceURL = openPanel.urls.first else {
				print("No file selected.")
				return nil
			}
			
			let destinationPath = try fileManager.url(
				for: .documentDirectory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
			)
			
			let destinationURL = destinationPath
				.appendingPathComponent("attachments")
			
			try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
			
			print("Source Path: \(sourceURL.path)")
			print("Destination Path: \(destinationURL.path)")
			
			let fileDestination = destinationURL.appendingPathComponent(sourceURL.lastPathComponent)

			if fileManager.fileExists(atPath: sourceURL.path) {
				try fileManager.copyItem(
					at: sourceURL,
					to: fileDestination
				)
				
				return Attachment(filename: sourceURL.lastPathComponent, path: fileDestination)
			} else {
				print("Source file does not exist at \(sourceURL)")
			}
			
		} catch {
			print("Error: \(error.localizedDescription)")
			return nil
		}
	}
	
	return nil
}
