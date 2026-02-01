import Foundation
import KeyStashModels

public final class AppScanner: AppScanning {
	private let applicationsURL: URL
	private let fileManager: FileManager
	private let apps: [AppInfo]

	public init() {
		applicationsURL = URL(fileURLWithPath: "/Applications")
		fileManager = FileManager.default

		var arr = [AppInfo]()

		do {
			let appURLs = try fileManager.contentsOfDirectory(
				at: applicationsURL,
				includingPropertiesForKeys: nil,
				options: .skipsHiddenFiles
			)

			for appURL in appURLs {
				if let bundle = Bundle(url: appURL), let bundleID = bundle.bundleIdentifier {
					arr.append(AppInfo(location: appURL, bundleID: bundleID))
				}
			}
		} catch {
			print("ERROR: \(error)")
		}

		apps = arr
	}

	public func allApps() -> [AppInfo] {
		return apps
	}

	public func userApps() -> [AppInfo] {
		return apps.filter { !isSystemApp(bundleID: $0.bundleID) }
	}

	private func isSystemApp(bundleID: String) -> Bool {
		return bundleID.hasPrefix("com.apple")
	}
}
