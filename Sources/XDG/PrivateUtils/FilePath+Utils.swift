import Foundation

import SystemPackage



extension FilePath {
	
	init?(url: URL) {
		guard url.isFileURL else {
			return nil
		}
#if canImport(Darwin)
		if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
			self.init(url.path(percentEncoded: false))
		} else {
			self.init(url.path)
		}
#elseif swift(>=6.0)
		self.init(url.path(percentEncoded: false))
#else
		self.init(url.path)
#endif
	}
	
	/* Returns self for convenience. */
	func ensureExistingParent(with fileManager: FileManager) throws -> Self {
		_ = try removingLastComponent().ensureExistingDir(with: fileManager)
		return self
	}
	
	/* Returns self for convenience. */
	func ensureExistingDir(with fileManager: FileManager) throws -> Self {
		try fileManager.createDirectory(atPath: string, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
		return self
	}
	
	func existsNotDir(with fileManager: FileManager) -> Bool {
		var isDir = ObjCBool(true)
		return (fileManager.fileExists(atPath: string, isDirectory: &isDir) && !isDir.boolValue)
	}
	
	func lexicallyResolving(_ subpath: FilePath) throws -> FilePath {
		guard let ret = lexicallyResolving(subpath) else {
			throw Err.pathGoesOut
		}
		return ret
	}
	
}
