import AppKit
import UniformTypeIdentifiers

final class FileService {
	let fileManager = FileManager.default
	
	@MainActor func chooseSaveDirectoryPath(defaultFileName: String, allowedTypes: [UTType]) -> String? {
		let savePanel = NSSavePanel()
		savePanel.allowedContentTypes = [.commaSeparatedText]
		savePanel.nameFieldStringValue = defaultFileName
		
		if savePanel.runModal() == .OK {
			return savePanel.url?.path
		}
		
		return nil
	}
	
	@MainActor func chooseFilePath(allowedTypes: [UTType], multipleSelection: Bool?) -> String? {
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
					let csv = try String(contentsOf: path, encoding: .utf8)
					return csv
				} catch {
					logger.error("ERROR: \(error)")
				}
			}
		}
		
		return nil
	}

	func getDirectoryPath(_ directory: FileManager.SearchPathDirectory) throws -> URL {
		do {
			let directoryPath = try fileManager.url(
				for: directory,
				in: .userDomainMask,
				appropriateFor: nil,
				create: true
			)
			
			return directoryPath
		} catch {
			throw error
		}
	}
}
