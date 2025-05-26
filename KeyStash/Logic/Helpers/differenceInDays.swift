import Foundation

func differenceInDays(date1: Date, date2: Date) -> Int {
	let calendar = Calendar.current
	let components = calendar.dateComponents([.day], from: date1, to: date2)
	return abs(components.day ?? 0)
}
