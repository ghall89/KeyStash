import Foundation

/*  determine if a given URL is a link to a macOS application download
and return a boolean */

func isDownloadLink(url: URL) -> Bool {
	let pathExtension = url.pathExtension.lowercased()
	let downloadExtensions: [String] = ["zip", "dmg", "app"]
	
	return downloadExtensions.contains(pathExtension)
}
