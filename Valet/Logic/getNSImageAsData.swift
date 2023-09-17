import Foundation
import AppKit

func getNSImageAsData(image: NSImage) -> Data? {
	guard let tiffData = image.tiffRepresentation else {
		return nil
	}
	
	guard let bitmapImageRep = NSBitmapImageRep(data: tiffData) else {
		return nil
	}
	
	let properties: [NSBitmapImageRep.PropertyKey: Any] = [
		.compressionFactor: 1.0
	]
	
	if let imageData = bitmapImageRep.representation(using: .png, properties: properties) {
		return imageData
	}
	
	return nil
}

