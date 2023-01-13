// swift-tools-version:5.7
import PackageDescription



let commonSwiftSettings: [SwiftSetting] = [
	// .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
	//	.unsafeFlags(["-Xfrontend", "-warn-concurrency", "-Xfrontend", "-enable-actor-data-race-checks"])
]


let package = Package(
	name: "swift-xdg",
	platforms: [
		.macOS(.v12), /* File path exists on macOS 11, but is unusable. */
		.tvOS(.v14),
		.iOS(.v14),
		.watchOS(.v7)
	],
	products: {
		var ret = [Product]()
		ret.append(.library(name: "XDG", targets: ["XDG"]))
		return ret
	}(),
	dependencies: {
		var ret = [Package.Dependency]()
#if !canImport(System)
		ret.append(.package(url: "https://github.com/apple/swift-system.git", from: "1.0.0"))
#endif
		return ret
	}(),
	targets: {
		var ret = [Target]()
		ret.append(.target(name: "XDG", dependencies: {
			var ret = [Target.Dependency]()
#if !canImport(System)
			ret.append(.product(name: "SystemPackage",  package: "swift-system"))
#endif
			return ret
		}(), swiftSettings: commonSwiftSettings))
		ret.append(.testTarget(name: "XDGTests", dependencies: ["XDG"], swiftSettings: commonSwiftSettings))
		return ret
	}()
)
