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
	
	/**
	 We get the home directory from FileManager, which returns a URL for the current user directory.
	 The user can technically not be a file URL.
	 This should not happen. */
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
