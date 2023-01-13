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
	
	func configFilePath(for path: FilePath) -> FilePath {
		return configHome.pushing(userPrefix).pushing(path)
	}
	
	func dataFilePath(for path: FilePath) -> FilePath {
		return dataHome.pushing(userPrefix).pushing(path)
	}
	
	func cacheFilePath(for path: FilePath) -> FilePath {
		return cacheHome.pushing(userPrefix).pushing(path)
	}
	
	func stateFilePath(for path: FilePath) -> FilePath {
		return stateHome.pushing(userPrefix).pushing(path)
	}
	
	/**
	 Get the runtime file path.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func runtimeFilePath(for path: FilePath) throws -> FilePath {
		return try runtimeDir.get().pushing(userPrefix).pushing(path)
	}
	
}
