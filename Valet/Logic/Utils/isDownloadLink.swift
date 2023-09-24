import Foundation

func isDownloadLink(url: URL) -> Bool {
	let pathExtension = url.pathExtension.lowercased()
	let downloadExtensions: [String] = ["zip", "dmg", "app"]
	
	return downloadExtensions.contains(pathExtension)
}
