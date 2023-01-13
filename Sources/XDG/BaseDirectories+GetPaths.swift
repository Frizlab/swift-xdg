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
	
	func configFilePath(for path: FilePath) throws -> FilePath {
		return try configHome.lexicallyResolving(userPrefix).lexicallyResolving(path)
	}
	
	func dataFilePath(for path: FilePath) throws -> FilePath {
		return try dataHome.lexicallyResolving(userPrefix).lexicallyResolving(path)
	}
	
	func cacheFilePath(for path: FilePath) throws -> FilePath {
		return try cacheHome.lexicallyResolving(userPrefix).lexicallyResolving(path)
	}
	
	func stateFilePath(for path: FilePath) throws -> FilePath {
		return try stateHome.lexicallyResolving(userPrefix).lexicallyResolving(path)
	}
	
	/**
	 Get the runtime file path.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func runtimeFilePath(for path: FilePath) throws -> FilePath {
		return try runtimeDir.get().lexicallyResolving(userPrefix).lexicallyResolving(path)
	}
	
}
