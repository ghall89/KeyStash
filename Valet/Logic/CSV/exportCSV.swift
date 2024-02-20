import Foundation
import AppKit

func exportCSV(licenses: [License]) {
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
	var csvString = "Name,URL,Registered To,Email,License Key,Notes\n"
	
	let licenses = data.sorted { $0.softwareName < $1.softwareName }
	
	for license in licenses {
		let row = "\(license.softwareName),\(license.downloadUrlString),\(license.registeredToName),\(license.registeredToEmail),\(license.licenseKey),\(license.notes)\n"
		csvString.append(row)
	}
	
	return csvString
}

func chooseFilePath() -> String? {
	let savePanel = NSSavePanel()
	savePanel.allowedContentTypes = [.commaSeparatedText]
	savePanel.nameFieldStringValue = "licenses.csv"
	
	if savePanel.runModal() == .OK {
		return savePanel.url?.path
	}
	
	return nil
}
