import SwiftUI

final class SettingsState: ObservableObject {
	@AppStorage("defaultName") var defaultName: String = ""
	@AppStorage("defaultEmail") var defaultEmail: String = ""
	@AppStorage("requireUserAuth") var requireUserAuth: Bool = false
//	@AppStorage("requireAuthAfter") var requireAuthAfter: MinutesUntilLocked = .fiveMinutes
	
	@AppStorage("selectedSort") var selectedSort: SortOptions = .byName
	@AppStorage("selectedSortOrder") var selectedSortOrder: OrderOptions = .asc
}
