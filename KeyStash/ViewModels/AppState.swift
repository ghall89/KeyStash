import Foundation
import SwiftUI

// determines various global UI states
final class AppState: ObservableObject {
	@AppStorage("defaultName") var defaultName: String = ""
	@AppStorage("defaultEmail") var defaultEmail: String = ""
	@AppStorage("requireUserAuth") var requireUserAuth: Bool = false
	//	@AppStorage("requireAuthAfter") var requireAuthAfter: MinutesUntilLocked = .fiveMinutes
	
	@AppStorage("selectedSort") var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") var selectedSortOrder: OrderOptions = .asc
	
	// display modal sheets
	@Published var showNewAppSheet: Bool = false
	@Published var showEditAppSheet: Bool = false
	@Published var showImportCSVSheet: Bool = false

	@Published var confirmDeleteAll: Bool = false
	@Published var confirmDeleteOne: Bool = false
	@Published var licenseToDelete: License?

	// misc
	@Published var sidebarSelection: SidebarSelection = .all
	@Published var selectedLicense = Set<String>()
	@Published var splitViewVisibility = NavigationSplitViewVisibility.all

	func resetSelection() {
		selectedLicense = []
	}
}

enum SidebarSelection: String {
	case all = "All"
	case expired = "Expired"
	case deleted = "Deleted"
}
