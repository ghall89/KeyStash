import Foundation
import SwiftUI

// determines various global UI states
class AppState: ObservableObject {
	// display modal sheets
	@Published var showNewAppSheet: Bool = false
	@Published var showEditAppSheet: Bool = false
	@Published var showImportCSVSheet: Bool = false
	
	@Published var confirmDeleteAll: Bool = false

	// display toast
	@Published var showToast: Bool = false
	@Published var toastMessage: String = ""

	// misc
	@Published var sidebarSelection: String = "all_apps"
	@Published var selectedLicense: String? = nil
	@Published var splitViewVisibility = NavigationSplitViewVisibility.all
	
	func triggerToast(message: String) {
		print(message)
		self.showToast = true
		self.toastMessage = message
	}
	
	 func resetSelection(itemId: String) {
		if itemId == self.selectedLicense {
			self.selectedLicense = nil
		}
	}
}
