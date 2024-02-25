import Foundation
import SwiftCloudDrive

func iCloudStore() async {
	do {
		let drive = try await CloudDrive(ubiquityContainerIdentifier: "iCloud.com.ghalldev.SerialBox")
	} catch {
		logger.error("ERROR: \(error)")
	}
}
