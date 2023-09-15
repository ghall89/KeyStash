import SwiftUI

struct AddLicense: View {
	@Environment(\.modelContext) private var modelContext
	@Binding var newItemSheet: Bool
	
	@State var newItem: License = License(softwareName: "", icon: nil, licenseKey: "", registeredToName: "", registeredToEmail: "", downloadUrlString: "", notes: "")
	
	@State var installedApps: [InstalledApp] = []
	@State var selectedApp: UUID = UUID()
	
	var body: some View {
		Form {
			Picker("App Name:", selection: $selectedApp, content: {
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
			TextField("Download Link:", text: $newItem.downloadUrlString)
			TextField("Registered To:", text: $newItem.registeredToName)
			TextField("Email:", text: $newItem.registeredToEmail)
			TextField("License Key:", text: $newItem.licenseKey)
				.lineLimit(4, reservesSpace: true)
			TextEditor(text: $newItem.notes)
				.frame(height: 100)
			HStack {
				Spacer()
				Button("Cancel", action: {
					newItemSheet.toggle()
				})
				Button("Save", action: addItem)
					.keyboardShortcut(.defaultAction)
			}
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
		newItemSheet.toggle()
	}
}
