import Foundation

final class EditFormState: ObservableObject {
	@Published var icon: Data? = nil
	@Published var softwareName: String = ""
	@Published var version: String = ""
	@Published var urlString: String = ""
	@Published var registeredToName: String = ""
	@Published var registeredToEmail: String = ""
	@Published var licenseKey: String = ""
	@Published var purchaseDt: Date? = nil
	@Published var addExpiration: Bool = false
	@Published var expirationDt: Date? = nil
	@Published var notes: String = ""
}
