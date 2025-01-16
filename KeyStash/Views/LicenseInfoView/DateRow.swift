import SwiftUI

struct DateRow: View {
	var label: String
	var value: Date?

	init(_ label: String, value: Date?) {
		self.label = label
		self.value = value
	}

	var valueString: String {
		let now = Date()
		if let dateToCompare = value {
			let dateString = value?.formatted(date: .complete, time: .omitted) ?? ""
			let daysLeft = differenceInDays(date1: now, date2: dateToCompare)
			let parensString = isPast() ? "Expired" : "\(daysLeft) Days Left"

			return "\(dateString) (\(parensString))"
		}

		return ""
	}

	func isPast() -> Bool {
		let now = Date()

		if let dateToCompare = value {
			return dateToCompare < now
		}

		return false
	}

	var body: some View { HStack(alignment: .top) {
		if value != nil {
			VStack(alignment: .leading) {
				Text(label)
					.font(.caption)
				Text(valueString)
					.foregroundStyle(isPast() ? Color.red : Color.primary)
			}
			.multilineTextAlignment(.leading)
			Spacer()
		}
	}
	.padding(.leading, 30)
	}
}
