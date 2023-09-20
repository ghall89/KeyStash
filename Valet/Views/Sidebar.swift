import SwiftUI

struct Sidebar: View {
    var body: some View {
			List {
				Label("All Apps", systemImage: "square.stack")
				Section("Tags") {
					Label("Sample Tag", systemImage: "tag")
				}
				Section {
					Label("Trash", systemImage: "trash")
				}
			}
    }
}
