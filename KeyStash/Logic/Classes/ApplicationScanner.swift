import AppKit
import ApplicationInspector
import Combine

final class ApplicationScanner: ObservableObject {
	@Published private(set) var applications: [Application] = []

	private let appInspector: ApplicationInspector

	init() async throws {
		do {
			appInspector = try await .init(excludeSystemApps: true)
			let apps = appInspector.installedApplications
				.compactMap { try? $0.get() }
				.sorted { $0.name.lowercased() < $1.name.lowercased() }

			applications = apps

		} catch {
			print("Failed to initialize AppScanner")
			throw error
		}
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
