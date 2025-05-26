import SwiftUI

struct SearchTextFieldStyle: TextFieldStyle {
	@Environment(\.controlActiveState) private var controlActiveState
	@FocusState private var textFieldFocused: Bool
	@State private var clearButtonScale: CGFloat = Constants.outScale
	@State private var windowIsActive: Bool = true

	@Binding var text: String

	func _body(configuration: TextField<Self._Label>) -> some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(Color.gray)
			configuration
				.textFieldStyle(.plain)
				.focused($textFieldFocused)

			// show clear button when text exists
			if !text.isEmpty {
				Button(
					action: clearText,
					label: {
						Image(systemName: "xmark.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: Constants.xMarkSize, height: Constants.xMarkSize, alignment: .center)
							.foregroundStyle(Color.primary.opacity(0.65))
							.scaleEffect(clearButtonScale)
							.animation(.easeInOut(duration: 0.1), value: clearButtonScale)
					}
				)
				.buttonStyle(.plain)
				.onAppear {
					clearButtonScale = Constants.inScale
				}
				.onDisappear {
					clearButtonScale = Constants.outScale
				}
			}
		}
		.onKeyPress(.escape) {
			if textFieldFocused {
				DispatchQueue.main.async {
					clearText()
				}

				return .handled
			}

			return .ignored
		}
		.padding(EdgeInsets(
			top: Constants.yPadding,
			leading: Constants.xPadding,
			bottom: Constants.yPadding,
			trailing: Constants.xPadding
		))
		.background {
			RoundedRectangle(cornerRadius: 5)
				.fill(Material.thick.opacity(textFieldFocused ? 1.0 : 0.0))
				.stroke(
					searchFieldBorderColor(),
					style: textFieldFocused ? .init(lineWidth: 4) : .init(lineWidth: 1)
				)
		}
		.onTapGesture {
			textFieldFocused = true
		}
		.onChange(of: controlActiveState) {
			DispatchQueue.main.async {
				switch controlActiveState {
					case .active:
						windowIsActive = true
					case .key:
						windowIsActive = true
					case .inactive:
						windowIsActive = false
					default:
						logger.error("Unable to get window state")
				}
			}
		}
	}

	private func searchFieldBorderColor() -> Color {
		if textFieldFocused && windowIsActive {
			return Color.accentHighlight
		} else if textFieldFocused {
			return Color.clear
		}

		return Color.border
	}

	private func clearText() {
		if !text.isEmpty {
			text = ""
		}
	}
}

private enum Constants {
	static let xMarkSize = 12.0
	static let outScale = 0.5
	static let inScale = 1.0
	static let xPadding = 6.0
	static let yPadding = 4.0
}
