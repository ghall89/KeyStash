import Foundation
import AppKit
import SwiftData

@Model
final class License {
	@Attribute(.unique) var id: UUID = UUID()
	var softwareName: String
	var icon: Data?
	@Attribute(.allowsCloudEncryption) var attachment: Data?
	@Attribute(.allowsCloudEncryption) var licenseKey: String
	@Attribute(.allowsCloudEncryption) var registeredToName: String
	@Attribute(.allowsCloudEncryption) var registeredToEmail: String
	var downloadUrlString: String
	@Attribute(.allowsCloudEncryption) var notes: String
	var createdDate: Date = Date()
	var updatedDate: Date?
	var tags: [String]?
	
	var inTrash: Bool
	var trashDate: Date?
	
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
		resizeImage(image: iconNSImage, toSize: NSSize(width: 24, height: 24))!
	}
	
	init(softwareName: String, icon: Data?, attachment: Data?, licenseKey: String, registeredToName: String, registeredToEmail: String, downloadUrlString: String, notes: String, updatedDate: Date? = nil, tags: [String]? = [], inTrash: Bool, trashDate: Date? = nil) {
		self.softwareName = softwareName
		self.icon = icon
		self.attachment = attachment
		self.licenseKey = licenseKey
		self.registeredToName = registeredToName
		self.registeredToEmail = registeredToEmail
		self.downloadUrlString = downloadUrlString
		self.notes = notes
		self.updatedDate = updatedDate
		self.tags = tags
		self.inTrash = inTrash
		self.trashDate = trashDate
	}
}
