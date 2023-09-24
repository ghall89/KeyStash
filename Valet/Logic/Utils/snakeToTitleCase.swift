import Foundation

func snakeToTitleCase(_ input: String) -> String {
	let words = input.split(separator: "_").map { String($0) }
	let capitalizedWords = words.map { $0.capitalized }
	return capitalizedWords.joined(separator: " ")
}
