import Foundation
import SwiftUI

// determines various global UI states
class AppState: ObservableObject {
	// display modal sheets
	@Published var showNewAppSheet: Bool = false
	@Published var showEditAppSheet: Bool = false
	@Published var showImportCSVSheet: Bool = false

	@Published var confirmDeleteAll: Bool = false
	@Published var confirmDeleteOne: Bool = false
	@Published var licenseToDelete: License?

	// misc
	@Published var sidebarSelection: SidebarSelection = .all
	@Published var selectedLicense: String? = nil
	@Published var splitViewVisibility = NavigationSplitViewVisibility.all

	func resetSelection() {
		selectedLicense = nil
	}
}

enum SidebarSelection: String {
	case all = "All"
	case expired = "Expired"
	case deleted = "Deleted"
}
