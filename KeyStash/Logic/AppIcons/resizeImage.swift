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
