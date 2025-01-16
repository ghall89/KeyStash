import Foundation
import SwiftUI

// determines various global UI states
class AppState: ObservableObject {
	// display modal sheets
	@Published var showNewAppSheet: Bool = false
	@Published var showEditAppSheet: Bool = false
	@Published var showImportCSVSheet: Bool = false

	@Published var confirmDeleteAll: Bool = false

	// misc
	@Published var sidebarSelection: String = "all_apps"
	@Published var selectedLicense: String? = nil
	@Published var splitViewVisibility = NavigationSplitViewVisibility.all

	func resetSelection(itemId: String) {
		if itemId == selectedLicense {
			selectedLicense = nil
		}
	}
}
