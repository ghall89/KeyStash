import KeyStashModels
import SwiftUI

public final class SettingsState: ObservableObject {
	@AppStorage("defaultName") public var defaultName = ""
	@AppStorage("defaultEmail") public var defaultEmail = ""
	@AppStorage("requireUserAuth") public var requireUserAuth = false
//	@AppStorage("requireAuthAfter") var requireAuthAfter: MinutesUntilLocked = .fiveMinutes

	@AppStorage("selectedSort") public var selectedSort = SortOptions.byName
	@AppStorage("selectedSortOrder") public var selectedSortOrder = OrderOptions.asc

	public init() {}
}
