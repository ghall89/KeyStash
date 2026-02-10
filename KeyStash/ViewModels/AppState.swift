import Foundation
import SwiftUI

/// determines various global UI states
final class AppState: ObservableObject {
	@AppStorage("defaultName") var defaultName: String = ""
	@AppStorage("defaultEmail") var defaultEmail: String = ""
	@AppStorage("requireUserAuth") var requireUserAuth: Bool = false

	@AppStorage("selectedSort") var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") var selectedSortOrder: OrderOptions = .asc

	/// persist sidebar visibility
	@AppStorage("splitViewVisibility") private var splitViewVisibilityStorage: String = "all"

	@Published var splitViewVisibility: NavigationSplitViewVisibility = .all {
		didSet {
			splitViewVisibilityStorage = splitViewVisibility.storageValue
		}
	}

	// display modal sheets
	@Published var showNewAppSheet: Bool = false
	@Published var showEditAppSheet: Bool = false
	@Published var showImportCSVSheet: Bool = false

	@Published var confirmDeleteAll: Bool = false
	@Published var confirmDeleteOne: Bool = false
	@Published var licenseToDelete: License?

	// misc
	@Published var sidebarSelection: SidebarSelection = .all
	@Published var selectedLicense: Set<String> = []

	init() {
		splitViewVisibility = NavigationSplitViewVisibility(storageValue: splitViewVisibilityStorage)
	}

	func resetSelection() {
		selectedLicense = []
	}
}

enum SidebarSelection: String {
	case all = "All"
	case expired = "Expired"
	case deleted = "Deleted"
}

private extension NavigationSplitViewVisibility {
	var storageValue: String {
		switch self {
			case .all:
				"all"
			case .doubleColumn:
				"doubleColumn"
			case .detailOnly:
				"detailOnly"
			default:
				"all"
		}
	}

	init(storageValue: String) {
		self =
			switch storageValue {
				case "doubleColumn":
					.doubleColumn
				case "detailOnly":
					.detailOnly
				default:
					.all
			}
	}
}
