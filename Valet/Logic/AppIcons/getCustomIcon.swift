import AppKit
import Foundation

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
