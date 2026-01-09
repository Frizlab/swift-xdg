// swift-tools-version:5.7
import PackageDescription



let package = Package(
	name: "swift-xdg",
	products: [
		.library(name: "XDG", targets: ["XDG"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-system.git", from: "1.0.0"),
	],
	targets: [
		.target(name: "XDG", dependencies: [
			.product(name: "SystemPackage", package: "swift-system"),
		]),
		.testTarget(name: "XDGTests", dependencies: ["XDG"]),
	]
)
