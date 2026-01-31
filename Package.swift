// swift-tools-version: 6.2

import PackageDescription

let package = Package(
	name: "KeyStash",
	platforms: [.macOS(.v15)],
	dependencies: [
		.package(url: "https://github.com/groue/GRDB.swift.git", branch: "master"),
		.package(url: "https://github.com/gonzalezreal/NetworkImage.git", branch: "main"),
		.package(url: "https://github.com/gonzalezreal/swift-markdown-ui.git", branch: "main"),
	],
	targets: [
		.target(
			name: "AppScanner"
		),
		.executableTarget(
			name: "KeyStash",
			dependencies: [
				"AppScanner",
				.product(name: "GetApps", package: "swift-get-apps"),
				.product(name: "GRDB", package: "grdb.swift"),
				.product(name: "NetworkImage", package: "networkimage"),
				.product(name: "MarkdownUI", package: "swift-markdown-ui"),
			],
			resources: [
				.process("Assets/no_icon.png"),
				.process("AppIcon.png"),
			]
		),
	]
)
