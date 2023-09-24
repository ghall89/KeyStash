import Foundation
import AppKit

func getAppIcon(identifier: String) -> NSImage? {
	print(identifier)
	if let appPath = NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) {
		print(appPath)
		let pathString = String(appPath.absoluteString.dropFirst(7))
		let appIcon = NSWorkspace.shared.icon(forFile: pathString)
		return appIcon
	}
	return nil
}
