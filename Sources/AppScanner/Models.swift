import AppKit
import Foundation

public struct AppInfo: Identifiable, Hashable {
	public var id = UUID()
	public var location: URL
	public var bundleID: String

	public var name: String {
		return location.deletingPathExtension().lastPathComponent
	}

	public var icon: NSImage? {
		getAppIcon(identifier: bundleID)
	}
}

private func getAppIcon(identifier: String) -> NSImage? {
	if let appPath = NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) {
		let pathString = String(appPath.absoluteString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " "))
		return NSWorkspace.shared.icon(forFile: pathString)
	}

	return nil
}
