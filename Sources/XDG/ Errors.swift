/*
 *  Errors.swift
 * swift-xdg
 *
 * Created by François Lamboley on 2023/01/13.
 */

import Foundation
#if canImport(System)
@preconcurrency import System
#else
@preconcurrency import SystemPackage
#endif



public enum XDGError : Error, Sendable {
	
	/** The OS does not support home directory, etc. */
	case cannotGetHomeOfUser
	
	public enum RuntimeDirError : Error, Sendable {
		
		case setupSkipped
		
		case runtimeDirIsMissing
		case runtimeDirIsNotADirectory(FilePath)
		case failedReadingRuntimeDirAttributes(FilePath)
		case runtimeDirIsNotOwnedByCurrentUser(FilePath, owner: String)
		case runtimeDirIsInsecure(FilePath, permissions: Int)

	}
	
}

typealias Err = XDGError
