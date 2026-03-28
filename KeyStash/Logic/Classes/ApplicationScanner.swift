import AppKit
import Combine

struct AppInfo: Identifiable, Equatable {
	let id: UUID
	let name: String
	let iconData: Data?
}

@MainActor
final class ApplicationScanner: ObservableObject {
	@Published private(set) var applications: [AppInfo] = []

	private var loadTask: Task<Void, Never>?

	init() async {
		await loadInstalledAppsIfNeeded()
	}

	func loadInstalledAppsIfNeeded() async {
		if !applications.isEmpty {
			return
		}

		if let loadTask {
			await loadTask.value
			return
		}

		let task = Task { @MainActor in
			let apps = await Self.scanApplications()
			self.applications = apps
		}

		loadTask = task
		defer {
			loadTask = nil
		}
		await task.value
	}

	func getIconByApplicationName(_ appName: String) -> Data? {
		applications.first(where: { $0.name == appName })?.iconData
	}

	func getInstalledApplications() -> [AppInfo] {
		applications
	}

	private static func scanApplications() async -> [AppInfo] {
		let fileManager = FileManager.default
		let appDirs: [String] = [
			"/Applications",
			"\(NSHomeDirectory())/Applications",
		]

		var apps: [AppInfo] = []

		for dir in appDirs {
			guard let contents = try? fileManager.contentsOfDirectory(atPath: dir) else { continue }
			for item in contents where item.hasSuffix(".app") {
				let fullPath = "\(dir)/\(item)"
				let url = URL(fileURLWithPath: fullPath)

				let name: String
				if let bundle = Bundle(url: url),
				   let displayName = (bundle.infoDictionary?["CFBundleDisplayName"] ?? bundle.infoDictionary?["CFBundleName"]) as? String {
					name = displayName
				} else {
					name = url.deletingPathExtension().lastPathComponent
				}

				let icon = NSWorkspace.shared.icon(forFile: fullPath)
				let iconData = getNSImageAsData(image: icon)
				apps.append(AppInfo(id: UUID(), name: name, iconData: iconData))
			}
		}

		return apps.sorted { $0.name.lowercased() < $1.name.lowercased() }
	}
}
