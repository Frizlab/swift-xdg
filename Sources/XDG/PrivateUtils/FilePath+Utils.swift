/*
 * FilePath+Utils.swift
 * swift-xdg
 *
 * Created by François Lamboley on 2023/01/13.
 */

import Foundation
#if canImport(System)
import System
#else
import SystemPackage
#endif



extension FilePath {
	
#if !canImport(System)
	init?(_ url: URL) {
		self.init(urlForceLocalImplementation: url)
	}
#endif
	
	/* In certain situations (custom toolchain), even on macOS where System can be imported, FilePath.init(_ url:) might not exist… */
	init?(urlForceLocalImplementation url: URL) {
		guard url.isFileURL else {
			return nil
		}
		self.init(url.path)
	}
	
	var url: URL {
		/* For now we do not consider Windows. */
#if !os(Linux)
		if #available(macOS 13.0, tvOS 16.0, iOS 16.0, watchOS 9.0, *) {
			return URL(filePath: string)
		} else {
			return URL(fileURLWithPath: string)
		}
#else
		return URL(fileURLWithPath: string)
#endif
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
