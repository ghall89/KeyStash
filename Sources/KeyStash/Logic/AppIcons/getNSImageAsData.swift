import AppKit
import Foundation

func getNSImageAsData(image: NSImage) -> Data? {
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
