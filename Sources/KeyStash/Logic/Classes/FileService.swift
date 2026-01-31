import AppKit
import UniformTypeIdentifiers

final class FileService {
	let fileManager = FileManager.default

	@MainActor
	func chooseSaveDirectoryPath(defaultFileName: String, allowedTypes _: [UTType]) -> String? {
		let savePanel = NSSavePanel()
		savePanel.allowedContentTypes = [.commaSeparatedText]
		savePanel.nameFieldStringValue = defaultFileName

		if savePanel.runModal() == .OK {
			return savePanel.url?.path
		}

		return nil
	}

	@MainActor
	func chooseFilePath(allowedTypes _: [UTType], multipleSelection _: Bool?) -> String? {
		let openPanel = NSOpenPanel()
		openPanel.allowsMultipleSelection = false
		openPanel.allowedContentTypes = [.commaSeparatedText]

		if openPanel.runModal() == .OK {
			guard let path = openPanel.urls.first else {
				logger.warning("No file selected.")
				return nil
			}

			if fileManager.fileExists(atPath: path.path) {
				do {
					return try String(contentsOf: path, encoding: .utf8)
				} catch {
					logger.error("ERROR: \(error)")
				}
			}
		}

		return nil
	}

	func getDirectoryPath(_ directory: FileManager.SearchPathDirectory) throws -> URL {
		do {
			return try fileManager.url(
				for: directory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
			)
		} catch {
			throw error
		}
	}
}
