import AppKit
import ApplicationInspector
import SwiftUI

final class AddLicenseViewModel: ObservableObject {
	@Published var newItem: License = .init(softwareName: "", icon: nil, licenseKey: "", registeredToName: "", registeredToEmail: "", downloadUrlString: "", notes: "", inTrash: false)
	@Published var tabSelection: TabSelection = .installed
	@Published var selectedApp: UUID?
}

struct AddLicenseView: View {
	@EnvironmentObject private var databaseManager: DatabaseManager
	@EnvironmentObject private var appState: AppState
	@StateObject private var viewModel = AddLicenseViewModel()

	var body: some View {
		VStack(spacing: 10) {
			if !appState.appList.isEmpty {
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
						if appState.appList.isEmpty {
							Text(appState.isLoadingInstalledApps ? "Loading..." : "No installed apps found")
								.tag(Optional<UUID>.none)
						} else {
							ForEach(appState.appList) { app in
								Text(app.name)
									.tag(Optional(app.id))
							}
						}
					})
					.disabled(appState.appList.isEmpty)
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
				.disabled(
					(viewModel.tabSelection == .custom && viewModel.newItem.softwareName.isEmpty) ||
					(viewModel.tabSelection == .installed && viewModel.selectedApp == nil)
				)
			}
			.padding(.top)
		}
		.frame(width: 400)
		.padding()
		.task {
			await loadInstalledApps()
		}
		.onChange(of: appState.appList) { _, apps in
			updateSelection(using: apps)
		}
	}

	private func addItem() {
		let newId = viewModel.newItem.id
		withAnimation {
			if viewModel.tabSelection == .installed {
				if
					let selectedApp = viewModel.selectedApp,
					let appFromList = appState.appList.first(where: { $0.id == selectedApp })
				{
					viewModel.newItem.softwareName = appFromList.name
					viewModel.newItem.registeredToName = appState.defaultName
					viewModel.newItem.registeredToEmail = appState.defaultEmail
					viewModel.newItem.icon = appFromList.iconData ?? getNSImageAsData(image: NSImage(named: "no_icon") ?? .init())
				}
			}
		}
		do {
			try databaseManager.addLicense(data: viewModel.newItem)
			databaseManager.fetchData()
		} catch {
			logger.error("Failed to create license!")
		}

		appState.selectedLicense = [newId]
		appState.showNewAppSheet.toggle()
	}

	@MainActor
	private func loadInstalledApps() async {
		await appState.ensureAppScannerLoaded()
		let apps = appState.appList
		updateSelection(using: apps)
	}

	private func updateSelection(using apps: [Application]) {
		if apps.isEmpty {
			viewModel.tabSelection = .custom
			viewModel.selectedApp = nil
		} else if let selectedApp = viewModel.selectedApp, apps.contains(where: { $0.id == selectedApp }) {
			return
		} else {
			viewModel.selectedApp = apps[0].id
		}
	}
}

enum TabSelection {
	case installed
	case custom
}
