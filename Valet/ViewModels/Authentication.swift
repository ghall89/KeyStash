import Foundation

class Authentication: ObservableObject {
	@Published var lockApp: Bool
	@Published var isAuthenticated: Bool
	
	init(lockApp: Bool, isAuthenticated: Bool) {
		self.lockApp = lockApp
		self.isAuthenticated = isAuthenticated
	}
}
