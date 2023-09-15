import Foundation
import AppKit

func getNSImageAsData(image: NSImage) -> Data? {
	guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
		return nil
	}
	
	let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
	let imageRect = CGRect(origin: .zero, size: imageSize)
	
	let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
	
	bitmapRep.size = imageSize
	bitmapRep.size = imageRect.size
	
	if let imageData = bitmapRep.representation(using: .png, properties: [:]) {
		return imageData
	}
	
	return nil
}
