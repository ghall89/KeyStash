import SwiftUI

struct AddLicenseView: View {
	@EnvironmentObject var databaseManager: DatabaseManager
	@EnvironmentObject var appState: AppState

	@AppStorage("defaultName") private var defaultName: String = ""
	@AppStorage("defaultEmail") private var defaultEmail: String = ""

	@State private var newItem: License = .init(softwareName: "", icon: nil, licenseKey: "", registeredToName: "", registeredToEmail: "", downloadUrlString: "", notes: "", inTrash: false)
	@State private var tabSelection: String = "installed"
	@State private var installedApps: [InstalledApp] = []
	@State private var selectedApp: UUID = .init()

	var body: some View {
		VStack(spacing: 10) {
			if !installedApps.isEmpty {
				Picker("", selection: $tabSelection) {
					Text("Choose Installed").tag("installed")
					Text("Add Manually").tag("custom")
				}
				.pickerStyle(.segmented)
				.padding(.bottom)
			}
			switch tabSelection {
				case "installed":
					Picker("Select App: ", selection: $selectedApp, content: {
						ForEach(installedApps) { app in
							Text(app.name)
								.tag(app.id)
						}
					})
				case "custom":
					HStack {
						VStack {
							Image(nsImage: newItem.iconNSImage)
								.resizable()
								.aspectRatio(contentMode: .fit)
							Button("Select Icon...", action: {
								if let iconData = getCustomIcon() {
									newItem.icon = iconData
								}
							})
						}
						.frame(width: 160, height: 100)
						Form {
							TextField("App Name: ", text: $newItem.softwareName)
						}
					}
				default:
					Text("🤔")
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
				.disabled(tabSelection == "custom" && newItem.softwareName.count == 0)
			}
			.padding(.top)
		}
		.frame(width: 400)
		.padding()
		.onAppear {
			let apps = getInstalledApps()
			if apps.isEmpty {
				tabSelection = "custom"
			} else {
				installedApps = apps
				selectedApp = apps[0].id
			}
		}
	}

	private func addItem() {
		let newId = newItem.id
		withAnimation {
			if tabSelection == "installed" {
				if let appFromList = installedApps.first(where: { $0.id == selectedApp }) {
					newItem.softwareName = appFromList.name
					newItem.registeredToName = defaultName
					newItem.registeredToEmail = defaultEmail
					newItem.icon = getNSImageAsData(image: ((appFromList.icon) ?? NSImage(named: "no_icon"))!)
				}
			}
		}
		do {
			try addLicense(databaseManager.dbQueue, data: newItem)
			databaseManager.fetchData()
		} catch {
			logger.error("Failed to create license!")
		}

		appState.selectedLicense = newId
		appState.showNewAppSheet.toggle()
	}
}
