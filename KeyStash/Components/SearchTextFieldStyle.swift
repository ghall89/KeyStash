import SwiftUI

private let XMARK_SIZE = CGFloat(14.0)
private let OUT_SCALE = CGFloat(0.5)
private let IN_SCALE = CGFloat(1.0)

struct SearchTextFieldStyle: TextFieldStyle {
	@FocusState private var textFieldFocused: Bool
	@State private var clearButtonScale: CGFloat = OUT_SCALE

	@Binding var text: String

	func _body(configuration: TextField<Self._Label>) -> some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(Color.gray)
			configuration
				.textFieldStyle(.plain)
				.focused($textFieldFocused)
				.overlay(alignment: .trailing) {
					// show clear button when text exists
					if !text.isEmpty {
						Button(
							action: clearText,
							label: {
								Image(systemName: "xmark.circle.fill")
									.resizable()
									.scaledToFit()
									.frame(width: XMARK_SIZE, height: XMARK_SIZE, alignment: .center)
									.foregroundStyle(Color.gray)
									.scaleEffect(clearButtonScale)
									.animation(.easeInOut(duration: 0.1), value: clearButtonScale)
							}
						)
						.buttonStyle(.plain)
						.onAppear {
							clearButtonScale = IN_SCALE
						}
						.onDisappear {
							clearButtonScale = OUT_SCALE
						}
					}
				}
		}
		.onKeyPress(.escape) {
			if textFieldFocused {
				clearText()
				return .handled
			}

			return .ignored
		}
		.padding(4)
		.background {
			RoundedRectangle(cornerRadius: 5)
				.fill(Material.thick.opacity(textFieldFocused ? 1.0 : 0.0))
				.stroke(
					textFieldFocused ? Color.accentHighlight :
						Color.border,
					style: textFieldFocused ? .init(lineWidth: 4) : .init(lineWidth: 1)
				)
		}
	}

	private func clearText() {
		if !text.isEmpty {
			text = ""
		}
	}
}
