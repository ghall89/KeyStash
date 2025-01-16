import AppKit
import Foundation

// display file open dialog and copy selected file to application container

@MainActor func getAttachment() -> URL? {
	let openPanel = NSOpenPanel()
	let fileManager = FileManager.default

	openPanel.allowsMultipleSelection = false
	openPanel.canChooseFiles = true
	openPanel.canChooseDirectories = false

	if openPanel.runModal() == .OK {
		do {
			guard let sourceURL = openPanel.urls.first else {
				logger.warning("No file selected.")
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

			logger.log("Source: \(sourceURL.path)")
			logger.log("Destination: \(destinationURL.path)")

			let fileDestination = destinationURL.appendingPathComponent(sourceURL.lastPathComponent)

			if fileManager.fileExists(atPath: sourceURL.path) {
				try fileManager.copyItem(
					at: sourceURL,
					to: fileDestination
				)

				return fileDestination
			} else {
				logger.error("Source file does not exist at \(sourceURL)")
			}

		} catch {
			logger.error("ERROR: \(error)")
			return nil
		}
	}

	return nil
}
