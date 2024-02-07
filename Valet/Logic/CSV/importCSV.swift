import Foundation
import AppKit

func importCSV() {
	if let file = chooseFile() {
		print("Success!")
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
				print("Error: \(error.localizedDescription)")
			}
		}
	}
	
	return nil
}

//func decodeCSV(data: String) -> [License] {
//	
//}
