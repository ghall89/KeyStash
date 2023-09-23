import SwiftUI

struct Sidebar: View {
	@Binding var selection: String
	
	var body: some View {
		List(selection: $selection) {
			Label("All Apps", systemImage: "square.stack")
				.tag("all_apps")
			//			Section("Tags") {
			//				Label("Sample Tag", systemImage: "tag")
			//			}
			Section {
				Label("Trash", systemImage: "trash")
					.tag("trash")
			}
		}
	}
}
