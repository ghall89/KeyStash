import AppKit
import Foundation

extension String {
	func stripNewLines() -> String {
		let newlines = CharacterSet.newlines
		return self.components(separatedBy: newlines).joined()
	}
}

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
	var csvString = "Name,Verion,URL,Purchase Date,Expiration Date,Registered To,Email,License Key,Notes\n"

	let licenses = data.sorted { $0.softwareName < $1.softwareName }

	for license in licenses {
		let row: [String] = [
			license.softwareName,
			license.version ?? "",
			license.downloadUrlString,
			license.purchaseDt?.formatted(date: .numeric, time: .omitted) ?? "",
			license.expirationDt?.formatted(date: .numeric, time: .omitted) ?? "",
			license.registeredToName,
			license.registeredToEmail,
			license.licenseKey.stripNewLines(),
			license.notes.stripNewLines()
		]
		
		let rowString = row.joined(separator: ",")
		
		csvString.append(rowString + "\n")
	}
	print(csvString)
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
