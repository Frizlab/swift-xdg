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
	
	/**
	 This happens when the search or given relative path would make the resulting path go out of its relative source.
	 
	 If you search for the configuration file `../yolo.toml`, you will get this error as going outside the configuration dir is not allowed (at least by this XDG base dirs implementation). */
	case pathGoesOut
	
	case fileFoundExpectedDirectory(FilePath)
	
	public enum RuntimeDirError : Error, Sendable {
		
		case setupSkipped
		
		/* If RuntimeDirHandling is set to setup with a non-nil default value, this case does not happen. */
		case runtimeDirEnvIsUndefined
		
		case runtimeDirIsNotADirectory(FilePath)
		case failedReadingRuntimeDirAttributes(FilePath)
		case runtimeDirIsNotOwnedByCurrentUser(FilePath, owner: String)
		case runtimeDirIsInsecure(FilePath, permissions: Int)

	}
	
}

typealias Err = XDGError
