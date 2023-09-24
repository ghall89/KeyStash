import Foundation
import AppKit

struct InstalledApp: Identifiable, Hashable {
	var id: UUID = UUID()
	var url: URL
	var bundleId: String
	var name: String {
		return url.deletingPathExtension().lastPathComponent
	}
	var icon: NSImage? {
		getAppIcon(identifier: bundleId) ?? nil
	}
}
