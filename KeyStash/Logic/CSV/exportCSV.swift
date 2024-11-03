import AppKit
import Foundation

extension String {
	func stripNewLines() -> String {
		let newlines = CharacterSet.newlines
		return components(separatedBy: newlines).joined()
	}
}

@MainActor func exportCSV(licenses: [License]) {
	let csvString = convertToCSV(data: licenses)

	if let filePath = chooseFilePath() {
		do {
			try csvString.write(toFile: filePath, atomically: true, encoding: .utf8)
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
}

func convertToCSV(data: [License]) -> String {
	var csvString = ""
	
	var headers: [String] = []
	
	for field in CSVFields.allCases {
		headers.append(field.headerName())
	}
	
	let headerString = headers.joined(separator: ", ")
	
	csvString.append(headerString + "\n")
	
	let licenses = data.sorted { $0.softwareName < $1.softwareName }

	for license in licenses {
		var row: [String] = []

		for field in CSVFields.allCases {
			let value: String? = field.value(from: license)
			
			if let value = value {
				row.append(value)
			} else {
				row.append("")
			}
		}

		let rowString = row.joined(separator: ",")

		csvString.append(rowString + "\n")
	}
	
	return csvString
}

@MainActor func chooseFilePath() -> String? {
	let savePanel = NSSavePanel()
	savePanel.allowedContentTypes = [.commaSeparatedText]
	savePanel.nameFieldStringValue = "licenses.csv"

	if savePanel.runModal() == .OK {
		return savePanel.url?.path
	}

	return nil
}
