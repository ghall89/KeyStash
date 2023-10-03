import SwiftUI

struct Sidebar: View {
	@AppStorage("compactList") private var compactList: Bool = false
	
	@Binding var selection: String
	
	var body: some View {
		List(selection: $selection) {
			VStack {
				if compactList == false {
					Label("All Apps", systemImage: "square.stack" )
				} else {
					Text("All Apps")
				}
			}
			.tag("all_apps")
			//			Section("Tags") {
			//				Label("Sample Tag", systemImage: "tag")
			//			}
			Section {
				VStack {
					if compactList == false {
						Label("Trash", systemImage: "trash")
					} else {
						Text("Trash")
					}
				}
				.tag("trash")
			}
		}
	}
}
