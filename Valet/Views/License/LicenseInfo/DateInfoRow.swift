import SwiftUI

struct DateInfoRow: View {
	var value: Date?
	var label: String
	
	var body: some View {
		HStack(alignment: .top) {
			if value != nil {
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					Text(valueString())
						.foregroundStyle(isPast() ? Color.red : Color.primary)
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
		.padding(.leading, 20)
	}
	
	private func valueString() -> String {
		let now = Date()
		if let dateToCompare = value {
			let dateString = value?.formatted(date: .complete, time: .omitted) ?? ""
			let daysLeft = differenceInDays(date1: now, date2: dateToCompare)
			let parensString = isPast() ? "Expired" : "\(daysLeft) Days Left"
			
			return "\(dateString) (\(parensString))"
		}
		
		return ""
	}
	
	private func differenceInDays(date1: Date, date2: Date) -> Int {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.day], from: date1, to: date2)
		return abs(components.day ?? 0)
	}
	
	private func isPast() -> Bool {
		let now = Date()
		
		if let dateToCompare = value {
			return dateToCompare < now
		}
		
		return false
	}
}
