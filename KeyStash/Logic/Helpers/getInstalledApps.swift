import AppKit
import Foundation

func getAllApps() -> [InstalledApp] {
	let applicationsURL = URL(fileURLWithPath: "/Applications")
	let fileManager = FileManager.default
	var installedApps: [InstalledApp] = []

	do {
		let appURLs = try fileManager.contentsOfDirectory(at: applicationsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

		for appURL in appURLs {
			if let bundle = Bundle(url: appURL), let bundleId = bundle.bundleIdentifier {
				installedApps.append(InstalledApp(location: appURL, bundleId: bundleId))
			}
		}
	} catch {
		print("ERROR: \(error)")
	}

	return installedApps.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
}

func getUserApps() -> [InstalledApp] {
	let allApps = getAllApps()
	return allApps.filter { !isSystemApp(bundleId: $0.bundleId) }
}

private func isSystemApp(bundleId: String) -> Bool {
		return bundleId.hasPrefix("com.apple")
}

struct InstalledApp: Identifiable, Hashable {
	public var id: UUID = .init()
	public var location: URL
	public var bundleId: String
	public var name: String {
		return location.deletingPathExtension().lastPathComponent
	}
	
	public var icon: NSImage? {
		getAppIcon(identifier: bundleId)
	}
}
