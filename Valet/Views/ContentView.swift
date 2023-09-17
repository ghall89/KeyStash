import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var items: [License]
	
	@State var showNewItemSheet: Bool = false
	
	var body: some View {
		NavigationSplitView {
			Sidebar(newItemSheet: $showNewItemSheet)
				.navigationSplitViewColumnWidth(min: 180, ideal: 200)
		} detail: {
			VStack(spacing: 10) {
				Image(systemName: "app.dashed")
					.font(.system(size: 80, weight: .thin))
					.foregroundStyle(.secondary)
				Text("Select an item")
					.font(.title)
					.foregroundStyle(.secondary)
			}
				.navigationSplitViewColumnWidth(min: 400, ideal: 700)
		}
		.sheet(isPresented: $showNewItemSheet, content: {
			AddLicense(newItemSheet: $showNewItemSheet)
		})
	}
}


