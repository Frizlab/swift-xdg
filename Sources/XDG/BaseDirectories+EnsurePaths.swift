/*
 * BaseDirectories+Utils.swift
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



public extension BaseDirectories {
	
	/** Make sure the folders leading to the config file path exist and return it. */
	func ensureParentsForConfigFilePath(for path: FilePath) throws -> FilePath {
		let path = configHome.pushing(userPrefix).pushing(path)
		try ensureParents(of: path)
		return path
	}
	
	/** Make sure the folders leading to the data file path exist and return it. */
	func ensureParentsForDataFilePath(for path: FilePath) throws -> FilePath {
		let path = dataHome.pushing(userPrefix).pushing(path)
		try ensureParents(of: path)
		return path
	}
	
	/** Make sure the folders leading to the cache file path exist and return it. */
	func ensureParentsForCacheFilePath(for path: FilePath) throws -> FilePath {
		let path = cacheHome.pushing(userPrefix).pushing(path)
		try ensureParents(of: path)
		return path
	}
	
	/** Make sure the folders leading to the state file path exist and return it. */
	func ensureParentsForStateFilePath(for path: FilePath) throws -> FilePath {
		let path = stateHome.pushing(userPrefix).pushing(path)
		try ensureParents(of: path)
		return path
	}
	
	/**
	 Make sure the folders leading to the runtime file path exist and return it.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func ensureParentsForRuntimeFilePath(for path: FilePath) throws -> FilePath {
		let path = try runtimeDir.get().pushing(userPrefix).pushing(path)
		try ensureParents(of: path)
		return path
	}
	
	private func ensureParents(of path: FilePath) throws {
		try fileManager.createDirectory(at: path.removingLastComponent().url, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
	}
	
}
