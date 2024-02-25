import SwiftUI

struct SidebarView: View {
	@EnvironmentObject var appState: AppState
	
	@AppStorage("compactList") private var compactList: Bool = false

	var body: some View {
		List(selection: $appState.sidebarSelection) {
			Section {
				VStack {
					if compactList == false {
						Label("All Apps", systemImage: "square.stack")
					} else {
						Text("All Apps")
					}
				}
				.tag("all_apps")
			}
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
