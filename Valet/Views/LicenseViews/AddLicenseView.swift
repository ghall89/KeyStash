import SwiftUI

final class AddLicenseViewModel: ObservableObject {
	@Published var newItem: License = .init(softwareName: "", icon: nil, licenseKey: "", registeredToName: "", registeredToEmail: "", downloadUrlString: "", notes: "", inTrash: false)
	@Published var tabSelection: TabSelection = .installed
	@Published var installedApps: [InstalledApp] = []
	@Published var selectedApp: UUID = .init()
}

struct AddLicenseView: View {
	@EnvironmentObject private var databaseManager: DatabaseManager
	@EnvironmentObject private var appState: AppState
	@StateObject private var viewModel = AddLicenseViewModel()

	@AppStorage("defaultName") private var defaultName: String = ""
	@AppStorage("defaultEmail") private var defaultEmail: String = ""

	var body: some View {
		VStack(spacing: 10) {
			if !viewModel.installedApps.isEmpty {
				Picker("", selection: $viewModel.tabSelection) {
					Text("Choose Installed").tag(TabSelection.installed)
					Text("Add Manually").tag(TabSelection.custom)
				}
				.pickerStyle(.segmented)
				.padding(.bottom)
			}
			switch viewModel.tabSelection {
				case .installed:
					Picker("Select App: ", selection: $viewModel.selectedApp, content: {
						ForEach(viewModel.installedApps) { app in
							Text(app.name)
								.tag(app.id)
						}
					})
				case .custom:
					HStack {
						VStack {
							Image(nsImage: viewModel.newItem.iconNSImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
							Button("Select Icon...", action: {
								if let iconData = getCustomIcon() {
									viewModel.newItem.icon = iconData
								}
							})
						}
						.frame(width: 160, height: 100)
						Form {
							TextField("App Name: ", text: $viewModel.newItem.softwareName)
						}
					}
			}

			HStack {
				Spacer()
				Button("Cancel", action: {
					appState.showNewAppSheet.toggle()
				})
				Button("Add", action: {
					Task {
						addItem()
					}
				})
				.keyboardShortcut(.defaultAction)
				.disabled(viewModel.tabSelection == .custom && viewModel.newItem.softwareName.isEmpty)
			}
			.padding(.top)
		}
		.frame(width: 400)
		.padding()
		.onAppear {
			let apps = getInstalledApps()
			if apps.isEmpty {
				viewModel.tabSelection = .custom
			} else {
				viewModel.installedApps = apps
				viewModel.selectedApp = apps[0].id
			}
		}
	}

	private func addItem() {
		let newId = viewModel.newItem.id
		withAnimation {
			if viewModel.tabSelection == .installed {
				if let appFromList = viewModel.installedApps.first(where: { $0.id == viewModel.selectedApp }) {
					viewModel.newItem.softwareName = appFromList.name
					viewModel.newItem.registeredToName = defaultName
					viewModel.newItem.registeredToEmail = defaultEmail
					viewModel.newItem.icon = getNSImageAsData(image: ((appFromList.icon) ?? NSImage(named: "no_icon"))!)
				}
			}
		}
		do {
			try addLicense(databaseManager.dbQueue, data: viewModel.newItem)
			databaseManager.fetchData()
		} catch {
			logger.error("Failed to create license!")
		}

		appState.selectedLicense = newId
		appState.showNewAppSheet.toggle()
	}
}

enum TabSelection {
	case installed
	case custom
}
