import Foundation
import AppKit

func getAppIcon(appName: String) -> NSImage? {
	if let appPath = NSWorkspace.shared.fullPath(forApplication: appName) {
		let appIcon = NSWorkspace.shared.icon(forFile: appPath)
		return appIcon
	}
	return nil
}
