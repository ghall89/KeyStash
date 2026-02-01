// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "KeyStash",
	platforms: [.macOS(.v15)],
	dependencies: [
		.package(url: "https://github.com/groue/GRDB.swift.git", branch: "master"),
		.package(url: "https://github.com/gonzalezreal/swift-markdown-ui.git", branch: "main"),
	],
	targets: [
		.target(
			name: "KeyStashModels"
		),
		.target(
			name: "KeyStashState",
			dependencies: [
				"KeyStashModels",
			]
		),
		.target(
			name: "AppScanner",
			dependencies: [
				"KeyStashState",
				"KeyStashModels",
			]
		),
		.target(
			name: "KeyStashDB",
			dependencies: [
				"KeyStashState",
				"AppScanner",
				"KeyStashModels",
				.product(name: "GRDB", package: "grdb.swift"),
			]
		),
		.executableTarget(
			name: "KeyStash",
			dependencies: [
				"KeyStashDB",
				"KeyStashState",
				"KeyStashModels",
				.product(name: "MarkdownUI", package: "swift-markdown-ui"),
			],
			resources: [
				.process("Assets"),
			]
		),
	]
)
