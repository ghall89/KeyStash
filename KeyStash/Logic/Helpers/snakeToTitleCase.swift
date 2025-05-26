import Foundation

// convert a snake_case string to Title Case

func snakeToTitleCase(_ input: String) -> String {
	let words = input.split(separator: "_").map { String($0) }
	let capitalizedWords = words.map { $0.capitalized }
	return capitalizedWords.joined(separator: " ")
}
