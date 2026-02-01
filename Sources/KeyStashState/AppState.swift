import Foundation
import KeyStashModels
import SwiftUI

/// determines various global UI states
public final class AppState: ObservableObject {
	// display modal sheets
	@Published public var showNewAppSheet = false
	@Published public var showEditAppSheet = false
	@Published public var showImportCSVSheet = false

	@Published public var confirmDeleteAll = false
	@Published public var confirmDeleteOne = false
	@Published public var licenseToDelete: License?

	// misc
	@Published public var sidebarSelection = SideBarSelection.all
	@Published public var selectedLicense = Set<String>()
	@Published public var splitViewVisibility = NavigationSplitViewVisibility.all

	public init() {}

	public func resetSelection() {
		selectedLicense = []
	}
}
