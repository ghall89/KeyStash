import Foundation
import AppKit
import GRDB

struct License: Identifiable, Codable, FetchableRecord, PersistableRecord {
	var id: String = UUID().uuidString
	var softwareName: String = ""
	var icon: Data?
	var licenseKey: String = ""
	var registeredToName: String = ""
	var registeredToEmail: String = ""
	var downloadUrlString: String = ""
	var notes: String = ""
	var createdDate: Date = Date()
	var updatedDate: Date?
	
	// trash status
	var inTrash: Bool = false
	var trashDate: Date?

	// attachment
	var attachmentPath: URL?
	
	// convert download string to a URL
	var downloadUrl: URL? {
		return URL(string: downloadUrlString)
	}
	
	// decode the icon PNG blob to NSImage
	var iconNSImage: NSImage {
		if let iconData = icon {
			return NSImage(data: iconData)!
		}
		
		return NSImage(named: "no_icon")!
	}
	
	// create small icon for list view, for best performance
	var miniIcon: NSImage {
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 24, height: 24)
		)!
	}
	
	init(
		softwareName: String,
		icon: Data?,
		attachmentPath: URL? = nil,
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
		self.attachmentPath = attachmentPath
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
