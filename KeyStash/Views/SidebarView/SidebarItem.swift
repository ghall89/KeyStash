import SwiftUI

struct SidebarItem: View {
	@EnvironmentObject var appState: AppState
	@State var mouseDown = false

	let button: SidebarButtonProps
	let count: Int

	var body: some View {
		let selected = button.key == appState.sidebarSelection
		let unselectedOpacity = mouseDown ? 0.8 : 0.3
		
		var rect: RectagleModifiers {
			if #available(macOS 26.0, *) {
				return RectagleModifiers(radius: 20, height: 70, padding: 12)
			} else {
				return RectagleModifiers(radius: 10, height: 60, padding: 8)
			}
		}

		Button(action: {
			appState.sidebarSelection = button.key
			appState.resetSelection()
		}) {
			RoundedRectangle(cornerRadius: rect.radius)
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
					.padding(rect.padding)
				}
				.frame(height: rect.height)
		}
		.buttonStyle(.plain)
		.focusable(false)
	}
	
	private struct RectagleModifiers {
		var radius: CGFloat
		var height: CGFloat
		var padding: CGFloat
	}
}
