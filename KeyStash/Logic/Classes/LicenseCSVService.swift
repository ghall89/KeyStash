import Foundation
import GetApps

final class LicenseCSVService {
	let fileService: FileService
	let formatter: DateFormatter
	
	init() {
		fileService = .init()
		formatter = .init()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
	}
	
	@MainActor func exportCSV(licenses: [License]) {
		let csvString = convertToCSV(data: licenses)
		
		if let filePath = fileService.chooseSaveDirectoryPath(
			defaultFileName: "licenses.csv",
			allowedTypes: [.commaSeparatedText]
		) {
			do {
				try csvString.write(toFile: filePath, atomically: true, encoding: .utf8)
			} catch {
				logger.error("ERROR: \(error)")
			}
		}
	}
	
	@MainActor func importCSV(_ dbService: DatabaseService, refetch: () -> Void) {

		
		if let fileString = fileService.chooseFilePath(
			allowedTypes: [.commaSeparatedText],
			multipleSelection: false
		) {
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
					try dbService.addLicense(data: importedLicense)
					
					refetch()
				} catch {
					logger.error("ERROR: \(error)")
				}
			}
		}
	}
	
	private func convertToCSV(data: [License]) -> String {
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
	
	private func getImportedIcon(_ appName: String) -> Data? {
		let apps = getUserApps()
		
		return apps.first(where: { $0.name == appName })?.icon.flatMap { getNSImageAsData(image: $0) }
	}
	
	private enum CSVFields: String, CaseIterable {
		case softwareName
		case version
		case downloadUrlString
		case purchaseDt
		case expirationDt
		case registeredToName
		case registeredToEmail
		case licenseKey
		case notes
		
		func value(from licence: License) -> String {
			switch self {
				case .softwareName:
					return licence.softwareName
				case .version:
					return licence.version ?? ""
				case .downloadUrlString:
					return licence.downloadUrlString
				case .purchaseDt:
					return licence.purchaseDt?.ISO8601Format() ?? ""
				case .expirationDt:
					return licence.expirationDt?.ISO8601Format() ?? ""
				case .registeredToName:
					return licence.registeredToName
				case .registeredToEmail:
					return licence.registeredToEmail
				case .licenseKey:
					return licence.licenseKey
				case .notes:
					return licence.notes
			}
		}
		
		func headerName() -> String {
			switch self {
				case .softwareName:
					return "Name"
				case .version:
					return "Version"
				case .downloadUrlString:
					return "URL"
				case .purchaseDt:
					return "Purchase Date"
				case .expirationDt:
					return "Expiration"
				case .registeredToName:
					return "Registered To"
				case .registeredToEmail:
					return "Registered To Email"
				case .licenseKey:
					return "License Key"
				case .notes:
					return "Notes"
			}
		}
	}
}
