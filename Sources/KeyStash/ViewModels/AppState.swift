import Foundation
import SwiftUI

/// determines various global UI states
final class AppState: ObservableObject {
	// display modal sheets
	@Published var showNewAppSheet = false
	@Published var showEditAppSheet = false
	@Published var showImportCSVSheet = false

	@Published var confirmDeleteAll = false
	@Published var confirmDeleteOne = false
	@Published var licenseToDelete: License?

	// misc
	@Published var sidebarSelection = SidebarSelection.all
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
