import AppKit
import ApplicationInspector
import Combine

final class ApplicationScanner: ObservableObject {
	private let appInspector: ApplicationInspector
	@Published private(set) var applications: [Application] = []

	init() async throws {
		do {
			appInspector = try await .init(excludeSystemApps: true)
			let apps = appInspector.installedApplications
				.compactMap { try? $0.get() }
				.sorted { $0.name < $1.name }
			await MainActor.run {
				self.applications = apps
			}
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
		guard let iconPath else {
			return nil
		}

		let iconImage: NSImage = .init(byReferencing: iconPath)
		return getNSImageAsData(image: iconImage)
	}
}
