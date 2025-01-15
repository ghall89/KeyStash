import AppKit
import Foundation
import GRDB
import GetApps

@MainActor func importCSV(_ dbQueue: DatabaseQueue, refetch: () -> Void) {
	let formatter = DateFormatter()
	formatter.locale = Locale(identifier: "en_US_POSIX")
	formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
	
	
	if let fileString = chooseFile() {
		var lines = fileString.components(separatedBy: "\n")
		lines.removeFirst(1)
		lines.removeLast(1)
		
		
		for (_, line) in lines.enumerated() {
			let fields = line.trimmingCharacters(in: CharacterSet(charactersIn: "\"")).components(separatedBy: ",")
			
			var importedLicense = License(
				softwareName: "",
				icon: nil as Data?,
				licenseKey: "",
				registeredToName: "",
				registeredToEmail: "",
				downloadUrlString: "",
				notes: "",
				inTrash: false
			)
			
			
			
			importedLicense.softwareName = fields[0]
			importedLicense.version = fields[1]
			importedLicense.downloadUrlString = fields[2]
			if !fields[3].isEmpty {
				importedLicense.purchaseDt = formatter.date(from: fields[3])
			}
			if !fields[4].isEmpty {
				importedLicense.expirationDt = formatter.date(from: fields[4])
			}
			importedLicense.registeredToName = fields[5]
			importedLicense.registeredToEmail = fields[6]
			importedLicense.licenseKey = fields[7]
			importedLicense.notes = fields[8]
			
			if let importedAppIconData = getImportedIcon(importedLicense.softwareName) {
				importedLicense.icon = importedAppIconData
			}
			
			do {
				try addLicense(dbQueue, data: importedLicense)
				
				refetch()
			} catch {
				logger.error("ERROR: \(error)")
			}
		}
		

		
	}
}

@MainActor private func chooseFile() -> String? {
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

private func getImportedIcon(_ appName: String) -> Data? {
	let apps = getUserApps()
	
	if let app = apps.first(where: {$0.name == appName}) {
		return getNSImageAsData(image: app.icon!)
	}
	
	return nil
}
