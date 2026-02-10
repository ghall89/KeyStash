import AppKit
import ApplicationInspector
import Combine
import Dependencies
import SwiftUI

final class AddLicenseViewModel: ObservableObject {
	@Published var newItem: License = .init(softwareName: "", icon: nil, licenseKey: "", registeredToName: "", registeredToEmail: "", downloadUrlString: "", notes: "", inTrash: false)
	@Published var tabSelection: TabSelection = .installed
	@Published var selectedApp: UUID = .init()
}

@MainActor
final class ApplicationScannerObserver: ObservableObject {
	@Published private(set) var scanner: ApplicationScanner?
	private var cancellable: AnyCancellable?
	@Dependency(\.applicationScanner) private var applicationScanner

	var applications: [Application] {
		scanner?.applications ?? []
	}

	func loadIfNeeded() async {
		guard scanner == nil else {
			return
		}

		do {
			let scanner = try await applicationScanner()
			self.scanner = scanner
			cancellable = scanner.objectWillChange.sink { [weak self] _ in
				self?.objectWillChange.send()
			}
		} catch {
			logger.error("Failed to scan installed apps: \(error)")
		}
	}
}

struct AddLicenseView: View {
	@EnvironmentObject private var databaseManager: DatabaseManager
	@EnvironmentObject private var appState: AppState
	@StateObject private var scannerObserver = ApplicationScannerObserver()
	@StateObject private var viewModel = AddLicenseViewModel()

	var body: some View {
		VStack(spacing: 10) {
			if !scannerObserver.applications.isEmpty {
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
						ForEach(scannerObserver.applications) { app in
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
		.task {
			await loadInstalledApps()
		}
	}

	private func addItem() {
		let newId = viewModel.newItem.id
		withAnimation {
			if viewModel.tabSelection == .installed {
				if let appFromList = scannerObserver.applications.first(where: { $0.id == viewModel.selectedApp }) {
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
		await scannerObserver.loadIfNeeded()
		let apps = scannerObserver.applications
		if apps.isEmpty {
			viewModel.tabSelection = .custom
		} else if !apps.contains(where: { $0.id == viewModel.selectedApp }) {
			viewModel.selectedApp = apps[0].id
		}
	}
}

enum TabSelection {
	case installed
	case custom
}
