import AppKit
import Foundation

@MainActor func importCSV() {
	if let fileString = chooseFile() {
		let lines = fileString.components(separatedBy: "\"\n")
		for (_, line) in lines.enumerated() {
			let fields = line.trimmingCharacters(in: CharacterSet(charactersIn: "\"")).components(separatedBy: "\",\"")
			print(fields)
		}
	}
}

@MainActor func chooseFile() -> String? {
	let openPanel = NSOpenPanel()
	let fileManager = FileManager.default

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

// func decodeCSV(data: String) -> [License] {
//
// }
