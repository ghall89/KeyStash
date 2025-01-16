import SwiftUI

struct InfoButton: View {
	let label: String
	let value: String
	let onClick: () -> Void
	
	@State private var isHovering = false
	@State private var clicked = false
	
	var body: some View {
		Button(action: clickHandler, label: {
			Image(systemName: clicked ? "checkmark.circle.fill" : "doc.on.doc.fill")
				.foregroundStyle(.accent)
				.opacity(isHovering ? 1 : 0.5)
				.transition(.opacity)
				.animation(.easeInOut(duration: 0.15), value: isHovering)
				.contentTransition(.symbolEffect(.replace.magic(fallback: .upUp.byLayer), options: .nonRepeating))
			VStack(alignment: .leading) {
				Text(label)
					.font(.caption)
					.monospaced(false)
				Text(value)
			}
		})
		.buttonStyle(.plain)
		.padding(6)
		.background {
			RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .circular)
				.fill(.primary)
				.opacity(isHovering ? 0.05 : 0)
				.transition(.opacity)
				.animation(.easeInOut(duration: 0.15), value: isHovering)
		}
		.onHover(perform: { hovering in
			isHovering = hovering
		})
		.multilineTextAlignment(.leading)
	}
	
	private func clickHandler() {
		if clicked == false {
			onClick()
			clicked = true
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				yourFuncHere()
			}

			func yourFuncHere() {
				clicked = false
			}
		}
	}
}
