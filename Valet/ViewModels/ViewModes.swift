import Foundation
import SwiftUI

// determines various global UI states
class ViewModes: ObservableObject {
	@Published var editMode: Bool = false
	@Published var showNewAppSheet: Bool = false
	@Published var splitViewVisibility = NavigationSplitViewVisibility.all
}
