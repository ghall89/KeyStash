import Foundation
import AppKit

func importCSV() {
	if let file = chooseFile() {
		logger.log("Success!")
	}
}

func chooseFile() -> Data? {
	let openPanel = NSOpenPanel()
	
	openPanel.allowsMultipleSelection = false
	openPanel.allowedContentTypes = [.commaSeparatedText]
	
	if openPanel.runModal() == .OK {
		let path = openPanel.url?.path
		
		if let url = URL(string: path!) {
			do {
				let csvData = try Data(contentsOf: url)
				return csvData
			} catch {
				logger.error("ERROR: \(error)")
			}
		}
	}
	
	return nil
}

//func decodeCSV(data: String) -> [License] {
//	
//}
