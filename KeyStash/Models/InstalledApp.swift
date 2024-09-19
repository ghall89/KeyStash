import AppKit
import Foundation

struct InstalledApp: Identifiable, Hashable {
	var id: UUID = .init()
	var url: URL
	var bundleId: String
	var name: String {
		return url.deletingPathExtension().lastPathComponent
	}

	var icon: NSImage? {
		getAppIcon(identifier: bundleId) ?? nil
	}
}
