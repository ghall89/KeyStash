import SwiftUI

struct AddLicense: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	
	@State var newItem: License = License(softwareName: "", icon: nil, licenseKey: "", registeredToName: "", registeredToEmail: "", downloadUrlString: "", notes: "")
	@State var tabSelection: String = "installed"
	@State var installedApps: [InstalledApp] = []
	@State var selectedApp: UUID = UUID()
	
	var body: some View {
		VStack(spacing: 10) {
			Picker("", selection: $tabSelection) {
				Text("Installed Apps").tag("installed")
				Text("Custom App").tag("custom")
			}
			.pickerStyle(.segmented)
			Picker("Select App: ", selection: $selectedApp, content: {
				ForEach(installedApps) { app in
					HStack {
						ZStack {
							if let icon = app.icon {
								Image(nsImage: icon )
									.resizable()
							} else {
								Image("no_icon")
									.resizable()
							}
						}
						Text(app.name)
					}
					.tag(app.id)
				}
			})
			.padding(.top)
			HStack {
				Spacer()
				Button("Cancel", action: {
					dismiss()
				})
				Button("Save", action: addItem)
					.keyboardShortcut(.defaultAction)
			}
			.padding(.top)
		}
		.frame(width: 400)
		.padding()
		.onAppear {
			let apps = getInstalledApps()
			installedApps = apps
			selectedApp = apps[0].id
		}
		.onChange(of: selectedApp, {
			if let appFromList = installedApps.first(where: { $0.id == selectedApp }) {
				print(appFromList)
				newItem.softwareName = appFromList.name
				newItem.icon = getNSImageAsData(image: ((appFromList.icon) ?? NSImage(named: "no_icon"))!)
			}
		})
	}
	
	private func addItem() {
		withAnimation {
			modelContext.insert(newItem)
		}
		dismiss()
	}
}
