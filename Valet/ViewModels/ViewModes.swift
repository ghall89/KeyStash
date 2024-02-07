import Foundation
import SwiftUI

class ViewModes: ObservableObject {
	@Published var editMode: Bool = false
	@Published var showNewAppSheet: Bool = false
	@Published var splitViewVisibility = NavigationSplitViewVisibility.all
}
