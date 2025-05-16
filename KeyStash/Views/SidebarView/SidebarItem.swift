import SwiftUI

struct SidebarItem: View {
	@EnvironmentObject var appState: AppState
	@State var mouseDown = false

	let button: SidebarButtonProps
	let count: Int

	var body: some View {
		let selected = button.key == appState.sidebarSelection
		let unselectedOpacity = mouseDown ? 0.8 : 0.3

		Button(action: {
			appState.sidebarSelection = button.key
		}) {
			RoundedRectangle(cornerRadius: 10)
				.fill(selected ? button.color : Color.gray)
				.opacity(selected ? 1 : unselectedOpacity)
				.overlay {
					VStack(alignment: .leading, spacing: 6) {
						HStack {
							Circle()
								.fill(selected ? Color.white : button.color)
								.frame(width: 24, height: 24, alignment: .center)
								.overlay {
									Image(systemName: button.icon)
										.foregroundStyle(selected ? button.color : Color.white)
								}
							Spacer()
							Text("\(count)")
								.foregroundStyle(selected ? Color.white : Color.primary)
								.opacity(selected ? 0.7 : 1)
						}
						Text(button.key.rawValue)
							.foregroundStyle(selected ? Color.white : Color.primary)
					}
					.frame(maxWidth: .infinity)
					.padding(8)
				}
				.frame(height: 60)
		}
		.buttonStyle(.plain)
		.focusable(false)
	}
}
