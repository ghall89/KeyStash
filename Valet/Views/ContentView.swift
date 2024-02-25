import SwiftUI

struct ContentView: View {
	@EnvironmentObject var appState: AppState
	@EnvironmentObject var authentication: Authentication

	@AppStorage("disableAnimations") private var disableAnimations: Bool = false

	var body: some View {
		//		GeometryReader { geometry in
		//			ZStack {
		NavigationSplitView {
			SidebarView()
				.navigationSplitViewColumnWidth(min: 160, ideal: 230)
		} content: {
			LicenseListView()
				.navigationSplitViewColumnWidth(min: 340, ideal: 350)
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
			.toolbar {
				ToolbarItem(content: {
					Spacer()
				})
			}
		}

		//				if authentication.lockApp == true {
		//					VStack {
		//
		//						Image(systemName: authentication.isAuthenticated ? "lock.open.fill" : "lock.fill")
		//							.font(.system(size: 70))
		//							.animation(.snappy, value: authentication.isAuthenticated)
		//						Button("Unlock...", action: {
		//							authenticate()
		//						})
		//					}
		//					.frame(maxWidth: .infinity, maxHeight: .infinity)
		//					.background(.thickMaterial)
		//					.offset(y: authentication.isAuthenticated ? -geometry.size.height : 0)
		//					.animation(.easeInOut, value: authentication.isAuthenticated)
		//					.onAppear(perform: {
		//						authenticate()
		//					})
		//				}
		//			}
		//		}
	}

	//	private func authenticate() {
	//		if authentication.lockApp == true && authentication.isAuthenticated == false {
	//			authenticateUser(reason: "unlock app") { result in
	//				switch result {
	//					case .success(let success):
	//						authentication.isAuthenticated = success
	//						print("Authentication success: \(success)")
	//					case .failure(let error):
	//						print("Authentication failed with error: \(error)")
	//				}
	//			}
	//		}
	//	}
}
