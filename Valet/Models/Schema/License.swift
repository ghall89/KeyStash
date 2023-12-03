import Foundation
import AppKit
import GRDB

struct License: Identifiable, Codable, FetchableRecord, PersistableRecord {
	var id: UUID = UUID()
	var softwareName: String = ""
	var icon: Data?
	var attachmentId: UUID?
	var licenseKey: String = ""
	var registeredToName: String = ""
	var registeredToEmail: String = ""
	var downloadUrlString: String = ""
	var notes: String = ""
	var createdDate: Date = Date()
	var updatedDate: Date?
	
	var inTrash: Bool = false
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
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 24, height: 24)
		)!
	}
	
	init(
		softwareName: String,
		icon: Data?,
		attachmentId: UUID? = nil,
		licenseKey: String,
		registeredToName: String,
		registeredToEmail: String,
		downloadUrlString: String,
		notes: String,
		updatedDate: Date? = nil,
		inTrash: Bool,
		trashDate: Date? = nil
	) {
		self.softwareName = softwareName
		self.icon = icon
		self.attachmentId = attachmentId
		self.licenseKey = licenseKey
		self.registeredToName = registeredToName
		self.registeredToEmail = registeredToEmail
		self.downloadUrlString = downloadUrlString
		self.notes = notes
		self.updatedDate = updatedDate
		self.inTrash = inTrash
		self.trashDate = trashDate
	}
}
