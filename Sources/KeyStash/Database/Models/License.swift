import AppKit
import Foundation
import GRDB

struct License: Identifiable, Codable, Hashable {
	var id: String = UUID().uuidString
	var softwareName = ""
	var version: String?
	var icon: Data?
	var expirationDt: Date?
	var purchaseDt: Date?
	var licenseKey = ""
	var registeredToName = ""
	var registeredToEmail = ""
	var downloadURLString = ""
	var notes = ""
	var createdDate = Date()
	var updatedDate: Date?

	// trash status
	var inTrash = false
	var trashDate: Date?

	/// attachment
	var attachmentPath: URL?

	/// convert download string to a URL
	var downloadURL: URL? {
		return URL(string: downloadURLString)
	}

	/// decode the icon PNG blob to NSImage
	var iconNSImage: NSImage {
		if let iconData = icon {
			return NSImage(data: iconData)!
		}

		return NSImage(named: "no_icon")!
	}

	/// create small icon for list view, for best performance
	var miniIcon: NSImage {
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 24, height: 24)
		)!
	}

	/// create small icon for list view, for best performance
	var listIcon: NSImage {
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 42, height: 42)
		)!
	}
}

extension License: FetchableRecord, PersistableRecord {
	enum Columns {
		static let id = Column(CodingKeys.id)
		static let softwareName = Column(CodingKeys.softwareName)
		static let icon = Column(CodingKeys.icon)
		static let licenseKey = Column(CodingKeys.licenseKey)
		static let registeredToName = Column(CodingKeys.registeredToName)
		static let registeredToEmail = Column(CodingKeys.registeredToEmail)
		static let downloadURLString = Column(CodingKeys.downloadURLString)
		static let notes = Column(CodingKeys.notes)
		static let createdDate = Column(CodingKeys.createdDate)
		static let updatedDate = Column(CodingKeys.updatedDate)
		static let inTrash = Column(CodingKeys.inTrash)
		static let trashDate = Column(CodingKeys.trashDate)
		static let expirationDt = Column(CodingKeys.expirationDt)
		static let purchaseDt = Column(CodingKeys.purchaseDt)
		static let version = Column(CodingKeys.version)
	}
}
