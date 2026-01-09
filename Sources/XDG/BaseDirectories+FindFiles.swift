import Foundation

import SystemPackage



/* If merging of files is supported and you need all of the files for the given path. */
public extension BaseDirectories {
	
	func findConfigFiles(for path: FilePath) throws -> [FilePath] {
		return try Array(findAll(path, in: [configHomePrefixed] + configDirsPrefixed))
	}
	
	func findDataFiles(_ path: FilePath) throws -> [FilePath] {
		return try Array(findAll(path, in: [dataHomePrefixed] + dataDirsPrefixed))
	}
	
	func findCacheFiles(_ path: FilePath) throws -> [FilePath] {
		return try Array(findAll(path, in: [cacheHomePrefixed]))
	}
	
	func findStateFiles(_ path: FilePath) throws -> [FilePath] {
		return try Array(findAll(path, in: [stateHomePrefixed]))
	}
	
	func findRuntimeFiles(_ path: FilePath) throws -> [FilePath] {
		return try Array(findAll(path, in: [runtimeDirPrefixed.get()]))
	}
	
	internal func findAll(_ searched: FilePath, in candidates: [FilePath]) throws -> some Collection<FilePath> {
		let fileManager = fileManagerFactory()
		return try candidates.map{ try $0.lexicallyResolving(searched) }.lazy.filter{ $0.existsNotDir(with: fileManager) }
	}
	
}
