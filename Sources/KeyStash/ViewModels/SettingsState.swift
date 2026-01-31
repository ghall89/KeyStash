import SwiftUI

final class SettingsState: ObservableObject {
	@AppStorage("defaultName") var defaultName = ""
	@AppStorage("defaultEmail") var defaultEmail = ""
	@AppStorage("requireUserAuth") var requireUserAuth = false
//	@AppStorage("requireAuthAfter") var requireAuthAfter: MinutesUntilLocked = .fiveMinutes

	@AppStorage("selectedSort") var selectedSort = SortOptions.byName
	@AppStorage("selectedSortOrder") var selectedSortOrder = OrderOptions.asc
}
