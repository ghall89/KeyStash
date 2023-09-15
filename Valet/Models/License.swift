import Foundation
import AppKit
import SwiftData

@Model
final class License {
	var id: UUID = UUID()
	var softwareName: String
	var icon: Data?
	var licenseKey: String
	var registeredToName: String
	var registeredToEmail: String
	var downloadUrlString: String
	var notes: String
	
	var downloadUrl: URL? {
		return URL(string: downloadUrlString)
	}
	var iconNSImage: NSImage {
		if let iconData = icon {
			return NSImage(data: iconData)!
		}
		
		return NSImage(named: "no_icon")!
	}
	
	init(softwareName: String, icon: Data?, licenseKey: String, registeredToName: String, registeredToEmail: String, downloadUrlString: String, notes: String) {
		self.softwareName = softwareName
		self.icon = icon
		self.licenseKey = licenseKey
		self.registeredToName = registeredToName
		self.registeredToEmail = registeredToEmail
		self.downloadUrlString = downloadUrlString
		self.notes = notes
	}
}
