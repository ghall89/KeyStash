import AppKit
import Foundation

func resizeImage(image: NSImage, toSize targetSize: NSSize) -> NSImage? {
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

@MainActor
func getCustomIcon() -> Data? {
	let openPanel = NSOpenPanel()

	openPanel.allowsMultipleSelection = false
	openPanel.allowedContentTypes = [.png, .tiff, .icns]

	if openPanel.runModal() == .OK {
		let path = openPanel.url?.path

		let imgFile = NSImage(contentsOfFile: path!)

		return getNSImageAsData(image: imgFile!)
	}

	return nil
}
