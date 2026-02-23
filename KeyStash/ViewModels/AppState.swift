import Foundation
import SwiftUI
import ApplicationInspector
import Combine
import Dependencies

/// determines various global UI states
@MainActor
final class AppState: ObservableObject {
	@Published private(set) var appList: [Application] = []
	@Published private(set) var isLoadingInstalledApps: Bool = false

	private(set) var appScanner: ApplicationScanner?
	private var scannerCancellable: AnyCancellable?
	private var scannerSetupTask: Task<Void, Never>?
	@Dependency(\.applicationScanner) private var applicationScanner
	
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

	func ensureAppScannerLoaded() async {
		if let appScanner {
			appList = appScanner.applications
			return
		}

		if let scannerSetupTask {
			await scannerSetupTask.value
			return
		}

		isLoadingInstalledApps = true
		let task = Task { @MainActor [weak self] in
			guard let self else {
				return
			}

			do {
				if self.appScanner == nil {
					let scanner = try await self.applicationScanner()
					self.appScanner = scanner
					self.scannerCancellable = scanner.$applications.sink { [weak self] apps in
						self?.appList = apps
					}
				}

				try await self.appScanner?.loadInstalledAppsIfNeeded()
				self.appList = self.appScanner?.applications ?? []
			} catch {
				logger.error("Failed to scan installed apps: \(error)")
			}

			self.isLoadingInstalledApps = false
			self.scannerSetupTask = nil
		}
		scannerSetupTask = task
		await task.value
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
