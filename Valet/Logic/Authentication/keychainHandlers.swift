import Foundation
import Security

let keychainService = "com.ghalldev.SerialBox.isLocked"

func saveSettingToKeychain(value: Bool) {
	let data = Data([value ? 1 : 0])

	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword,
		kSecAttrService as String: keychainService,
		kSecValueData as String: data,
	]

	let status = SecItemAdd(query as CFDictionary, nil)

	if status != errSecSuccess {
		logger.error("Error saving to Keychain: \(status)")
	}
}

func retrieveSettingFromKeychain() -> Bool {
	let query: [String: Any] = [
		kSecClass as String: kSecClassGenericPassword,
		kSecAttrService as String: keychainService,
		kSecMatchLimit as String: kSecMatchLimitOne,
		kSecReturnData as String: kCFBooleanTrue!,
	]

	var retrievedData: AnyObject?
	let status = SecItemCopyMatching(query as CFDictionary, &retrievedData)

	if status == errSecSuccess, let data = retrievedData as? Data, let value = data.first {
		return value == 1
	} else {
		logger.error("Error retrieving from Keychain: \(status)")
		return false
	}
}
