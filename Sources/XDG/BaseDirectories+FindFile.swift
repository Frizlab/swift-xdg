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
	
	/* Not exactly the same as findConfigFiles(path).first because findBest is lazy. */
	func findConfigFile(_ path: FilePath) throws -> FilePath? {
		return try findBest(path, in: [configHomePrefixed] + configDirsPrefixed)
	}
	
	func findDataFile(_ path: FilePath) throws -> FilePath? {
		return try findBest(path, in: [dataHomePrefixed] + dataDirsPrefixed)
	}
	
	func findCacheFile(_ path: FilePath) throws -> FilePath? {
		return try findBest(path, in: [cacheHomePrefixed])
	}
	
	func findStateFile(_ path: FilePath) throws -> FilePath? {
		return try findBest(path, in: [stateHomePrefixed])
	}
	
	func findRuntimeFile(_ path: FilePath) throws -> FilePath? {
		return try findBest(path, in: [runtimeDirPrefixed.get()])
	}
	
	internal func findBest(_ searched: FilePath, in candidates: [FilePath]) throws -> FilePath? {
		return try findAll(searched, in: candidates).first{ _ in true }
	}
	
}
