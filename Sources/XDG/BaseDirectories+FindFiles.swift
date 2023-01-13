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
	
	func findConfigFile(_ path: FilePath) -> FilePath? {
		return find(path, in: configHome, and: configDirs)
	}
	
	func findDataFile(_ path: FilePath) -> FilePath? {
		return find(path, in: dataHome, and: dataDirs)
	}
	
	func findCacheFile(_ path: FilePath) -> FilePath? {
		return find(path, in: cacheHome)
	}
	
	func findStateFile(_ path: FilePath) -> FilePath? {
		return find(path, in: stateHome)
	}
	
	func findRuntimeFile(_ path: FilePath) throws -> FilePath? {
		return try find(path, in: runtimeDir.get())
	}
	
	private func find(_ searched: FilePath, in base: FilePath, and other: [FilePath] = []) -> FilePath? {
		let p1 = base.pushing(userPrefix).pushing(searched)
		if p1.existsNotDir(with: fileManager) {
			return p1
		}
		return other.first(where: {
			$0.pushing(sharedPrefix).pushing(searched).existsNotDir(with: fileManager)
		})
	}
	
}
