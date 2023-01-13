// swift-tools-version:5.7
import PackageDescription



let commonSwiftSettings: [SwiftSetting] = [
	// .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
	//	.unsafeFlags(["-Xfrontend", "-warn-concurrency", "-Xfrontend", "-enable-actor-data-race-checks"])
]


let package = Package(
	name: "swift-xdg",
	products: {
		var ret = [Product]()
		ret.append(.library(name: "XDG", targets: ["XDG"]))
		return ret
	}(),
	targets: {
		var ret = [Target]()
		ret.append(.target(name: "XDG", swiftSettings: commonSwiftSettings))
		ret.append(.testTarget(name: "XDGTests", dependencies: ["XDG"], swiftSettings: commonSwiftSettings))
		return ret
	}()
)
