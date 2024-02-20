import Foundation

// get and return a list of non-system apps installed on user's device

func getInstalledApps() -> [InstalledApp] {
	let applicationsURL = URL(fileURLWithPath: "/Applications")
	let fileManager = FileManager.default
	var nonSystemApps: [InstalledApp] = []
	
	do {
		let appURLs = try fileManager.contentsOfDirectory(at: applicationsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
		
		for appURL in appURLs {
			if isNonSystemApp(appURL: appURL), let bundle = Bundle(url: appURL) {
				let bundleId = bundle.bundleIdentifier
				nonSystemApps.append(InstalledApp(url: appURL, bundleId: bundleId!))
			}
		}
	} catch {
		logger.error("ERROR: \(error)")
	}
	
	return nonSystemApps.sorted { $0.name < $1.name }
}

func isNonSystemApp(appURL: URL) -> Bool {
	let bundle = Bundle(url: appURL)
	if let bundleIdentifier = bundle?.bundleIdentifier {
		// Adjust this condition based on your criteria for identifying system apps
		return !bundleIdentifier.hasPrefix("com.apple")
	}
	return false
}
