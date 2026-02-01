public enum SideBarSelection: String {
	case all = "All"
	case expired = "Expired"
	case deleted = "Deleted"
}

public enum SortOptions: String, CaseIterable {
	case byName
	case byAddedDt
	case byUpdatedDt

	func localizedString() -> String {
		switch self {
			case .byName: return String(localized: "SortOptions.byName")
			case .byAddedDt: return String(localized: "SortOptions.byAddedDt")
			case .byUpdatedDt: return String(localized: "SortOptions.byUpdatedDt")
		}
	}

	func icon() -> String {
		switch self {
			case .byName: return "textformat"
			case .byAddedDt: return "clock"
			case .byUpdatedDt: return "pencil.line"
		}
	}
}

public enum OrderOptions: String, CaseIterable {
	case asc
	case desc

	func localizedString() -> String {
		switch self {
			case .asc: return String(localized: "OrderOptions.asc")
			case .desc: return String(localized: "OrderOptions.desc")
		}
	}

	func icon() -> String {
		switch self {
			case .asc: return "arrow.up"
			case .desc: return "arrow.down"
		}
	}
}
