import SwiftUI

struct HighlightableText: View {
	let text: String
	let highlight: String
	
	var body: some View {
		let textArr = text.map { String($0) }
		
		return HStack(spacing: -0.5) {
			ForEach(textArr.indices, id: \.self) { index in
				let char = textArr[index]
				Text(char)
					.foregroundColor(getColor(index))
			}
		}
	}
	
	private func getColor(_ index: Int) -> Color {
		if let range = text.range(of: highlight, options: .caseInsensitive) {
			let startIndex = text.distance(from: text.startIndex, to: range.lowerBound)
			let endIndex = text.distance(from: text.startIndex, to: range.upperBound)
			
			if index >= startIndex && index < endIndex {
				return .orange
			}
		}
		return .primary
	}
}
