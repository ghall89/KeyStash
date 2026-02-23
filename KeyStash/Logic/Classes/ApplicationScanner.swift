import AppKit
import ApplicationInspector
import Combine

@MainActor
final class ApplicationScanner: ObservableObject {
	@Published private(set) var applications: [Application] = []

	private var appInspector: ApplicationInspector?
	private var loadTask: Task<Void, Error>?

	init() async throws {
		try await loadInstalledAppsIfNeeded()
	}

	func loadInstalledAppsIfNeeded() async throws {
		if appInspector != nil {
			return
		}

		if let loadTask {
			try await loadTask.value
			return
		}

		let task = Task { @MainActor in
			let inspector = try await ApplicationInspector(excludeSystemApps: true)
			let apps = inspector.installedApplications
				.compactMap { try? $0.get() }
				.sorted { $0.name.lowercased() < $1.name.lowercased() }

			self.appInspector = inspector
			self.applications = apps
		}

		loadTask = task
		defer {
			loadTask = nil
		}
		try await task.value
	}

	func getIconByApplicationName(_ appName: String) -> Data? {
		let matchingApp = applications.first(where: { $0.name == appName })

		guard let iconData = matchingApp?.iconData else {
			return nil
		}

		return iconData
	}

	func getInstalledApplications() -> [Application] {
		applications
	}
}

extension Application {
	var iconData: Data? {
		guard let iconImage: NSImage = getAppIcon() else {
			return nil
		}
		
		return getNSImageAsData(image: iconImage)
	}
	
	// more reliable way of getting an app icon (copied from swift-app-getter)
	private func getAppIcon() -> NSImage? {
		if let appPath = NSWorkspace.shared.urlForApplication(withBundleIdentifier: additionalDetails.bundleID) {
			let pathString = String(appPath.absoluteString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " "))
			let appIcon = NSWorkspace.shared.icon(forFile: pathString)
			return appIcon
		}
		
		return nil
	}
}
