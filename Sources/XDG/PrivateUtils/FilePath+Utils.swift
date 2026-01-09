import Foundation

import SystemPackage



extension FilePath {
	
	init?(url: URL) {
		guard url.isFileURL else {
			return nil
		}
		self.init(url.path)
	}
	
	/* Returns self for convenience. */
	func ensureExistingParent(with fileManager: FileManager) throws -> Self {
		return try removingLastComponent().ensureExistingDir(with: fileManager)
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
