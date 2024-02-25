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
					if viewModes.editMode == true {
						DatePicker(
							label,
							selection: $selectedDate,
							displayedComponents: [.date]
						)
					} else {
						Text(label)
							.font(.caption)
						Text(value?.formatted() ?? "")
					}
				}
				.multilineTextAlignment(.leading)
				Spacer()
			}
		}
		.onChange(of: selectedDate, {
			formValue = selectedDate
		})
	}
}
