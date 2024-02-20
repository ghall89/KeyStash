import AppKit
import SwiftUI

struct FilePickerView: NSViewControllerRepresentable {
	class Coordinator: NSObject, NSOpenSavePanelDelegate {
		var parent: FilePickerView
		
		init(parent: FilePickerView) {
			self.parent = parent
		}
		
		func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
			return url.pathExtension == "app"
		}
		
		func panel(_ sender: Any, didChangeToDirectoryURL url: URL?) {
			// Handle directory change
			// Optionally, you can perform actions when the directory changes
		}
		
		func panel(_ sender: Any, validate url: URL) throws {
			// Validate selected URL
		}
		
		func panelSelectionDidChange(_ sender: Any?) {
			// Handle selection change
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
	
	func makeNSViewController(context: Context) -> NSViewController {
		let viewController = NSViewController()
		let openPanel = NSOpenPanel()
		openPanel.allowedContentTypes = [.application]
		openPanel.delegate = context.coordinator
		openPanel.canChooseFiles = true
		openPanel.canChooseDirectories = false
		openPanel.canCreateDirectories = false
		openPanel.allowsMultipleSelection = false
		openPanel.directoryURL = URL(fileURLWithPath: "/Applications")
		
		viewController.view = NSHostingView(rootView: Text(""))
		openPanel.begin { response in
			if response == .OK, let url = openPanel.urls.first {
				// Handle selected URL
				// You can pass this URL to your SwiftUI view or perform any actions
				logger.log("Selected URL: \(url)")
			}
		}
		
		return viewController
	}
	
	func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
}

extension View {
	func filePicker(isPresented: Binding<Bool>) -> some View {
		background(
			FilePickerView()
				.opacity(0)
				.sheet(isPresented: isPresented) {
					self
				}
		)
	}
}
