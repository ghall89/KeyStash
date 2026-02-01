import Foundation

func daysUntilDeleted(date: Date?) -> String? {
	if let startDate = date {
		let calendar = Calendar.current
		var dateComponents = DateComponents()

		dateComponents.day = 30

		let deleteDate = calendar.date(byAdding: dateComponents, to: startDate)
		let difference = calendar.dateComponents([.day], from: startDate, to: deleteDate ?? Date())

		return "\(String(describing: difference.day)) Days"

	} else {
		return nil
	}
}
