import SwiftUI

struct InfoButton: View {
	let label: String
	let value: String
	let onClick: () -> Void
	let icon: SFSymbol
	
	@State var isHovering = false
	
	var body: some View {
		Button(action: onClick, label: {
			Image(systemName: icon.name)
				.foregroundStyle(.accent)
				.opacity(isHovering ? 1 : 0.5)
				.transition(.opacity)
				.animation(.easeInOut(duration: 0.15), value: isHovering)
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
}

enum SFSymbol {
	case document
	case arrowDown
	
	var name: String {
		switch self {
			case .document: return "doc.on.doc.fill"
			case .arrowDown: return "arrow.down.circle.fill"
		}
	}
}
