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
	func ensureConfigDirPath(_ path: FilePath) throws -> FilePath {
		return try configHome.lexicallyResolving(userPrefix).lexicallyResolving(path).ensureExistingDir(with: fileManager)
	}
	
	/** Make sure the folders leading to the data file path exist and return it. */
	func ensureDataDirPath(_ path: FilePath) throws -> FilePath {
		return try dataHome.lexicallyResolving(userPrefix).lexicallyResolving(path).ensureExistingDir(with: fileManager)
	}
	
	/** Make sure the folders leading to the cache file path exist and return it. */
	func ensureCacheDirPath(_ path: FilePath) throws -> FilePath {
		return try cacheHome.lexicallyResolving(userPrefix).lexicallyResolving(path).ensureExistingDir(with: fileManager)
	}
	
	/** Make sure the folders leading to the state file path exist and return it. */
	func ensureStateDirPath(_ path: FilePath) throws -> FilePath {
		return try stateHome.lexicallyResolving(userPrefix).lexicallyResolving(path).ensureExistingDir(with: fileManager)
	}
	
	/**
	 Make sure the folders leading to the runtime file path exist and return it.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func ensureRuntimeDirPath(_ path: FilePath) throws -> FilePath {
		return try runtimeDir.get().lexicallyResolving(userPrefix).lexicallyResolving(path).ensureExistingDir(with: fileManager)
	}
	
}
