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
	func ensureConfigDirPath(for path: FilePath) throws -> FilePath {
		return try configHome.pushing(userPrefix).pushing(path).ensureExistingDir(with: fileManager)
	}
	
	/** Make sure the folders leading to the data file path exist and return it. */
	func ensureDataDirPath(for path: FilePath) throws -> FilePath {
		return try dataHome.pushing(userPrefix).pushing(path).ensureExistingDir(with: fileManager)
	}
	
	/** Make sure the folders leading to the cache file path exist and return it. */
	func ensureCacheDirPath(for path: FilePath) throws -> FilePath {
		return try cacheHome.pushing(userPrefix).pushing(path).ensureExistingDir(with: fileManager)
	}
	
	/** Make sure the folders leading to the state file path exist and return it. */
	func ensureStateDirPath(for path: FilePath) throws -> FilePath {
		return try stateHome.pushing(userPrefix).pushing(path).ensureExistingDir(with: fileManager)
	}
	
	/**
	 Make sure the folders leading to the runtime file path exist and return it.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func ensureRuntimeDirPath(for path: FilePath) throws -> FilePath {
		return try runtimeDir.get().pushing(userPrefix).pushing(path).ensureExistingDir(with: fileManager)
	}
	
}
