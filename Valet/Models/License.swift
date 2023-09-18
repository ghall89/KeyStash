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
	var createdDate: Date = Date()
	var updatedDate: Date?
	
	var downloadUrl: URL? {
		return URL(string: downloadUrlString)
	}
	var iconNSImage: NSImage {
		if let iconData = icon {
			return NSImage(data: iconData)!
		}
		
		return NSImage(named: "no_icon")!
	}
	var miniIcon: NSImage {
		resizeImage(image: iconNSImage, toSize: NSSize(width: 16, height: 16))!
	}
	
	init(softwareName: String, icon: Data?, licenseKey: String, registeredToName: String, registeredToEmail: String, downloadUrlString: String, notes: String, updatedDate: Date? = nil) {
		self.softwareName = softwareName
		self.icon = icon
		self.licenseKey = licenseKey
		self.registeredToName = registeredToName
		self.registeredToEmail = registeredToEmail
		self.downloadUrlString = downloadUrlString
		self.notes = notes
		self.updatedDate = updatedDate
	}
}
