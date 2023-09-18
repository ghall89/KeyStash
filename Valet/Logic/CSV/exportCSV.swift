import Foundation
import AppKit

func exportCSV(licenses: [License]) {
	let csvString = convertToCSV(data: licenses)
	
	if let filePath = chooseFilePath() {
		do {
			try csvString.write(toFile: filePath, atomically: true, encoding: .utf8)
		} catch {
			print("Error exporting CSV file: \(error)")
		}
	}
}

func convertToCSV(data: [License]) -> String {
	var csvString = "Name,URL,Registered To,Email,License Key,Notes\n"
	
	for license in data {
		let row = "\(license.softwareName),\(license.downloadUrlString),\(license.registeredToName),\(license.registeredToEmail),\(license.licenseKey),\(license.notes)"
		print(row)
		csvString.append(row)
	}
	
	return csvString
}

func chooseFilePath() -> String? {
	let savePanel = NSSavePanel()
	savePanel.allowedFileTypes = ["csv"]
	savePanel.nameFieldStringValue = "licenses.csv"
	
	if savePanel.runModal() == .OK {
		return savePanel.url?.path
	}
	
	return nil
}
