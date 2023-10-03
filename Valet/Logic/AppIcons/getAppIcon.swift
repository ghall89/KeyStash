import Foundation
import AppKit

func getAppIcon(identifier: String) -> NSImage? {
	if let appPath = NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) {
		let pathString = String(appPath.absoluteString.dropFirst(7).dropLast(1).replacingOccurrences(of: "%20", with: " "))
		let appIcon = NSWorkspace.shared.icon(forFile: pathString)
		return appIcon
	}
	return nil
}
