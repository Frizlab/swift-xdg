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
	func ensureParentsForConfigFilePath(_ path: FilePath) throws -> FilePath {
		return try configHomePrefixed.lexicallyResolving(path).ensureExistingParent(with: fileManager)
	}
	
	/** Make sure the folders leading to the data file path exist and return it. */
	func ensureParentsForDataFilePath(_ path: FilePath) throws -> FilePath {
		return try dataHomePrefixed.lexicallyResolving(path).ensureExistingParent(with: fileManager)
	}
	
	/** Make sure the folders leading to the cache file path exist and return it. */
	func ensureParentsForCacheFilePath(_ path: FilePath) throws -> FilePath {
		return try cacheHomePrefixed.lexicallyResolving(path).ensureExistingParent(with: fileManager)
	}
	
	/** Make sure the folders leading to the state file path exist and return it. */
	func ensureParentsForStateFilePath(_ path: FilePath) throws -> FilePath {
		return try stateHomePrefixed.lexicallyResolving(path).ensureExistingParent(with: fileManager)
	}
	
	/**
	 Make sure the folders leading to the runtime file path exist and return it.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func ensureParentsForRuntimeFilePath(_ path: FilePath) throws -> FilePath {
		return try runtimeDirPrefixed.get().lexicallyResolving(path).ensureExistingParent(with: fileManager)
	}
	
}
