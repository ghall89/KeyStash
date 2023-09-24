import SwiftUI
import SwiftData
import MarkdownUI
import AlertToast

struct LicenceInfo: View {
	@EnvironmentObject var viewModes: ViewModes
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
										if isDownloadLink(url: url) {
											Label("Download", systemImage: "arrow.down.circle")
										} else {
											Label("Website", systemImage: "safari")
										}
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
					LicenseInfoRow(showToast: $showToast, value: $license.registeredToName, label: "Registered To")
					LicenseInfoRow(showToast: $showToast, value: $license.registeredToEmail, label: "Email")
					LicenseInfoRow(showToast: $showToast, value: $license.licenseKey, label: "License Key")
					AttachmentRow(file: $license.attachment)
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
			AlertToast(type: .complete(.accent), title: "Copied to Clipboard")
		}
		.onChange(of: license, {
			if viewModes.editMode == true {
				viewModes.editMode.toggle()
			}
		})
		.onAppear {
			if viewModes.editMode == true {
				viewModes.editMode.toggle()
			}
		}
		.toolbar {
			ToolbarItem {
				Spacer()
			}
			ToolbarItem {
				Button(action: {
					viewModes.editMode.toggle()
				}, label: {
					Image(systemName: viewModes.editMode == true ? "checkmark.circle.fill" : "square.and.pencil")
				})
			}
		}
	}
}
