import SwiftUI
import Observation
import AppKit

struct LicenceInfo: View {
	@State private var viewModes = ViewModes()
	@Bindable var license: License
	
	var body: some View {
		ScrollView {
			VStack {
				ZStack {
					Rectangle()
						.fill(.regularMaterial)
					HStack {
						Image(nsImage: license.iconNSImage)
							.resizable()
							.frame(width: 100, height: 100)
						VStack {
							Text(license.softwareName)
								.font(.title)
							if viewModes.editMode == true {
								TextField("URL", text: $license.downloadUrlString)
							} else {
								if let url = license.downloadUrl {
									Link("Download", destination: url)
								}
							}
						}
						Spacer()
					}
					.padding()
				}
				VStack(alignment: .leading, spacing: 12) {
					LicenseInfoRow(canEdit: $viewModes.editMode, value: $license.registeredToName, label: "Registered Name")
					LicenseInfoRow(canEdit: $viewModes.editMode, value: $license.registeredToEmail, label: "Registered Email")
					LicenseInfoRow(canEdit: $viewModes.editMode, value: $license.licenseKey, label: "License Key")
					Divider()
					Text("Notes")
						.font(.caption)
					Text(license.notes)
				}
				.frame(maxWidth: .infinity)
				.padding()
			}
		}
		.frame(maxWidth: .infinity)
		.toolbar {
			ToolbarItem {
				Button(action: {
					viewModes.editMode.toggle()
				}, label: {
					Image(systemName: viewModes.editMode == true ? "checkmark.circle.fill" : "pencil")
				})
			}
			
			ToolbarItem {
				Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
					Image(systemName: "square.and.arrow.up")
				})
				.disabled(viewModes.editMode)
			}
		}
	}
}
