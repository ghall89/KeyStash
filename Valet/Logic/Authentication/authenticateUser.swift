import LocalAuthentication

func authenticateUser(reason: String, completion: @escaping (Result<Bool, Error>) -> Void) {
	let context = LAContext()

	var error: NSError?
	if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
		context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
			DispatchQueue.main.async {
				if success {
					completion(.success(true))
				} else {
					completion(.success(false))
				}
			}
		}
	} else {
		context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { passcodeSuccess, _ in
			DispatchQueue.main.async {
				completion(.success(passcodeSuccess))
			}
		}
	}
}
