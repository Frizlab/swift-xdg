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
	
	func findConfigFile(_ path: FilePath) throws -> FilePath? {
		return try find(path, in: configHome, and: configDirs)
	}
	
	func findDataFile(_ path: FilePath) throws -> FilePath? {
		return try find(path, in: dataHome, and: dataDirs)
	}
	
	func findCacheFile(_ path: FilePath) throws -> FilePath? {
		return try find(path, in: cacheHome)
	}
	
	func findStateFile(_ path: FilePath) throws -> FilePath? {
		return try find(path, in: stateHome)
	}
	
	func findRuntimeFile(_ path: FilePath) throws -> FilePath? {
		return try find(path, in: runtimeDir.get())
	}
	
	private func find(_ searched: FilePath, in base: FilePath, and other: [FilePath] = []) throws -> FilePath? {
		let p1: FilePath = try base.lexicallyResolving(userPrefix).lexicallyResolving(searched)
		if p1.existsNotDir(with: fileManager) {
			return p1
		}
		return try other.first(where: {
			try $0.lexicallyResolving(sharedPrefix).lexicallyResolving(searched).existsNotDir(with: fileManager)
		})
	}
	
}
