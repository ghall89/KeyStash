import KeyStashModels

protocol AppScanning {
	func allApps() -> [AppInfo]
	func userApps() -> [AppInfo]
}
