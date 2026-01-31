import Foundation

final class EditFormState: ObservableObject {
	@Published var icon: Data? = nil
	@Published var softwareName = ""
	@Published var version = ""
	@Published var urlString = ""
	@Published var registeredToName = ""
	@Published var registeredToEmail = ""
	@Published var licenseKey = ""
	@Published var purchaseDt: Date? = nil
	@Published var addExpiration = false
	@Published var expirationDt: Date? = nil
	@Published var notes = ""
}
