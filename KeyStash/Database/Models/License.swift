import AppKit
import Foundation
import SQLiteData

@Table("license")
struct License: Identifiable, Codable, Hashable {
	var id: String = UUID().uuidString
	var softwareName: String = ""
	var version: String?
	var icon: Data?
	var expirationDt: Date?
	var purchaseDt: Date?
	var licenseKey: String = ""
	var registeredToName: String = ""
	var registeredToEmail: String = ""
	var downloadUrlString: String = ""
	var notes: String = ""
	var createdDate: Date = .init()
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

	// create small icon for list view, for best performance
	var listIcon: NSImage {
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 42, height: 42)
		)!
	}
}

