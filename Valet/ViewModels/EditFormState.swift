import Foundation

class EditFormState: ObservableObject {
	@Published var softwareName: String = ""
	@Published var urlString: String = ""
	@Published var registeredToName: String = ""
	@Published var registeredToEmail: String = ""
	@Published var licenseKey: String = ""
	@Published var expirationDt: Date? = nil
	@Published var notes: String = ""
}
