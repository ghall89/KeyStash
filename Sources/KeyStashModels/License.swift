import AppKit
import Foundation

public struct License: Identifiable, Codable, Hashable {
	public enum CodingKeys: String, CodingKey {
		case id
		case softwareName
		case icon
		case licenseKey
		case registeredToName
		case registeredToEmail
		case downloadURLString
		case notes
		case createdDate
		case updatedDate
		case inTrash
		case trashDate
		case expirationDt
		case purchaseDt
		case version
	}

	public var id: String = UUID().uuidString
	public var softwareName = ""
	public var version: String?
	public var icon: Data?
	public var expirationDt: Date?
	public var purchaseDt: Date?
	public var licenseKey = ""
	public var registeredToName = ""
	public var registeredToEmail = ""
	public var downloadURLString = ""
	public var notes = ""
	public var createdDate = Date()
	public var updatedDate: Date?

	// trash status
	public var inTrash = false
	public var trashDate: Date?

	/// attachment
	public var attachmentPath: URL?

	/// convert download string to a URL
	public var downloadURL: URL? {
		return URL(string: downloadURLString)
	}

	/// decode the icon PNG blob to NSImage
	public var iconNSImage: NSImage {
		if let iconData = icon {
			return NSImage(data: iconData)!
		}

		return NSImage(named: "no_icon")!
	}

	/// create small icon for list view, for best performance
	public var miniIcon: NSImage {
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 24, height: 24)
		)!
	}

	/// create small icon for list view, for best performance
	public var listIcon: NSImage {
		resizeImage(
			image: iconNSImage,
			toSize: NSSize(width: 42, height: 42)
		)!
	}

	private func resizeImage(image: NSImage, toSize targetSize: NSSize) -> NSImage? {
		let targetRect = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
		guard let representation = image.bestRepresentation(for: targetRect, context: nil, hints: nil) else {
			return nil
		}

		let targetImage = NSImage(size: targetSize)
		targetImage.lockFocus()
		defer { targetImage.unlockFocus() }

		if representation.draw(in: targetRect) {
			return targetImage
		}

		return nil
	}

	private func getNSImageAsData(image: NSImage) -> Data? {
		let targetSize = NSSize(width: 120, height: 120)

		guard let resizedImage = resizeImage(image: image, toSize: targetSize) else {
			return nil
		}

		if let tiffData = resizedImage.tiffRepresentation {
			let bitmapImageRep = NSBitmapImageRep(data: tiffData)
			let properties: [NSBitmapImageRep.PropertyKey: Any] = [
				.compressionFactor: 0.5,
			]

			if let imageData = bitmapImageRep?.representation(using: .png, properties: properties) {
				return imageData
			}
		}

		return nil
	}
}
