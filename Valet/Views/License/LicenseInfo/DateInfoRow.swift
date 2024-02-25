import SwiftUI

struct DateInfoRow: View {
	@EnvironmentObject var viewModes: ViewModes
	var value: Date?
	@Binding var formValue: Date?
	var label: String
	
	@State var selectedDate: Date = Date()
	
	var body: some View {
		HStack(alignment: .top) {
			if value != nil || viewModes.editMode == true {
				VStack(alignment: .leading) {
					Text(label)
						.font(.caption)
					if viewModes.editMode == true {
						DatePicker(
							"",
							selection: $selectedDate,
							displayedComponents: [.date]
						)
					} else {
						Text(value?.formatted(date: .complete, time: .omitted) ?? "")
					}
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
		.padding(.leading, 20)
		.onChange(of: selectedDate, {
			formValue = selectedDate
		})
	}
}
