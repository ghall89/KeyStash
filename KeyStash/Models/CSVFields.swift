import Foundation

enum CSVFields: String, CaseIterable {
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
				return licence.purchaseDt?.formatted(date: .numeric, time: .omitted) ?? ""
			case .expirationDt:
				return licence.expirationDt?.formatted(date: .numeric, time: .omitted) ?? ""
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
