import Foundation
import AppKit

func getCustomIcon() -> Data? {
	let openPanel = NSOpenPanel()
	
	openPanel.allowsMultipleSelection = false
	openPanel.allowedContentTypes = [.png, .tiff]
	
	if openPanel.runModal() == .OK {
		let path = openPanel.url?.path
		
		let imgFile = NSImage(contentsOfFile: path!)
		
		return getNSImageAsData(image: imgFile!)
	}
	
	return nil
}

