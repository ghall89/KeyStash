import SwiftUI
import Observation
import AppKit
import MarkdownUI
import AlertToast

struct LicenceInfo: View {
	@State private var viewModes = ViewModes()
	@State var showToast: Bool = false
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
							.aspectRatio(contentMode: .fit)
							.frame(width: 75)
						VStack {
							Text(license.softwareName)
								.font(.title)
								.multilineTextAlignment(.leading)
							if viewModes.editMode == true {
								TextField("URL", text: $license.downloadUrlString)
							} else {
								if let url = license.downloadUrl {
									Link(destination: url, label: {
										Label("Download", systemImage: "arrow.down.circle")
									})
									.buttonStyle(.borderedProminent)
								}
							}
						}
						Spacer()
					}
					.padding()
				}
				VStack(alignment: .leading, spacing: 12) {
					LicenseInfoRow(canEdit: $viewModes.editMode, showToast: $showToast, value: $license.registeredToName, label: "Registered Name")
					LicenseInfoRow(canEdit: $viewModes.editMode, showToast: $showToast, value: $license.registeredToEmail, label: "Registered Email")
					LicenseInfoRow(canEdit: $viewModes.editMode, showToast: $showToast, value: $license.licenseKey, label: "License Key")
					Divider()
					Text("Notes")
						.font(.caption)
					if viewModes.editMode == true {
						TextEditor(text: $license.notes)
							.frame(minHeight: 100)
					} else {
						Markdown(license.notes)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
			}
		}
		.frame(maxWidth: .infinity)
		.toast(isPresenting: $showToast) {
			AlertToast(type: .complete(.accent), title: "Copied")
		}
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
