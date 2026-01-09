import Foundation

import SystemPackage



public extension BaseDirectories {
	
	func configFilePath(for path: FilePath) throws -> FilePath {
		return try configHomePrefixed.lexicallyResolving(path)
	}
	
	func dataFilePath(for path: FilePath) throws -> FilePath {
		return try dataHomePrefixed.lexicallyResolving(path)
	}
	
	func cacheFilePath(for path: FilePath) throws -> FilePath {
		return try cacheHomePrefixed.lexicallyResolving(path)
	}
	
	func stateFilePath(for path: FilePath) throws -> FilePath {
		return try stateHomePrefixed.lexicallyResolving(path)
	}
	
	/**
	 Get the runtime file path.
	 
	 - Throws: If there was an error retrieving the runtime dir during the init of the `BaseDirectories` (checks for permissions and co are only done at init). */
	func runtimeFilePath(for path: FilePath) throws -> FilePath {
		return try runtimeDirPrefixed.get().lexicallyResolving(path)
	}
	
}
