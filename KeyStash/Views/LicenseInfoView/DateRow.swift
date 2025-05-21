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

	var body: some View { HStack(alignment: .top) {
		HStack {
			Text(label)
			Spacer()
			Text(valueString)
				.foregroundStyle(isPast() ? Color.red : Color.primary)
		}
	}
	.padding(.leading, 30)
	}

	private func isPast() -> Bool {
		let now = Date()

		if let dateToCompare = value {
			return dateToCompare < now
		}

		return false
	}
}
