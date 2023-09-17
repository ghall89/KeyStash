import Foundation

class ViewModes: ObservableObject {
	@Published var editMode: Bool = false
	@Published var showNewAppSheet: Bool = false
}
