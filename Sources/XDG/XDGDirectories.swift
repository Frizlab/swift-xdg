/*
 * XDGDirectories.swift
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



public struct XDGDirectories : Sendable {
	
	public var   dataHome: FilePath
	public var configHome: FilePath
	public var  cacheHome: FilePath
	public var  stateHome: FilePath
	
	public var   dataDirs: [FilePath]
	public var configDirs: [FilePath]
	
	public var runtimeDir: Result<FilePath, XDGError.RuntimeDirError>?
	
	public init(setupRuntimeDir: Bool = false, fileManager: FileManager = .default) throws {
		let home = Result<FilePath, Error>{
			/* I’ll not add the UnwrapOrThrow dependency just for a one time use, but this is tempting; I’d even be clearer w/ it probably… */
#if !os(tvOS) && !os(iOS) && !os(watchOS)
			guard let ret = FilePath(urlForceLocalImplementation: fileManager.homeDirectoryForCurrentUser) else {
				throw Err.cannotGetHomeOfUser
			}
			return ret
#else
			throw Err.cannotGetHomeOfUser
#endif
		}
		
		self.dataHome   = try Self.absolutePath(from: "XDG_DATA_HOME")   ?? home.get().appending(".local/share")
		self.configHome = try Self.absolutePath(from: "XDG_CONFIG_HOME") ?? home.get().appending(".config")
		self.cacheHome  = try Self.absolutePath(from: "XDG_CACHE_HOME")  ?? home.get().appending(".cache")
		self.stateHome  = try Self.absolutePath(from: "XDG_STATE_HOME")  ?? home.get().appending(".local/state")
		
		self.dataDirs   = Self.absolutePaths(from: "XDG_DATA_DIRS")   ?? [FilePath("/usr/local/share"), FilePath("/usr/share")]
		self.configDirs = Self.absolutePaths(from: "XDG_CONFIG_DIRS") ?? [FilePath("/etc/xdg")]
		
		self.runtimeDir = {
			guard setupRuntimeDir else {
				return .failure(.setupSkipped)
			}
			guard let dirPath = Self.absolutePath(from: "XDG_RUNTIME_DIR") else {
				return nil
			}
			var isDir = ObjCBool(false)
			guard fileManager.fileExists(atPath: dirPath.string, isDirectory: &isDir), isDir.boolValue else {
				return .failure(.runtimeDirIsNotADirectory(dirPath))
			}
			guard let attributes = try? fileManager.attributesOfItem(atPath: dirPath.string),
					let owner = attributes[.ownerAccountName] as? String,
					let posixPerms = attributes[.posixPermissions] as? Int
			else {
				return .failure(.failedReadingRuntimeDirAttributes(dirPath))
			}
			guard owner == NSUserName() else {
				return .failure(.runtimeDirIsNotOwnedByCurrentUser(dirPath, owner: owner))
			}
			guard posixPerms == 0o700 else {
				return .failure(.runtimeDirIsInsecure(dirPath, permissions: posixPerms))
			}
			/* TODO: Check ACL, maybe, but mostly all the other restrictions of the runtime dir from the specs.
			 *
			 * These, I don’t think I can check:
			 * The lifetime of the directory MUST be bound to the user being logged in.
			 * It MUST be created when the user first logs in and if the user fully logs out the directory MUST be removed.
			 * If the user logs in more than once he should get pointed to the same directory,
			 *  and it is mandatory that the directory continues to exist from his first login to his last logout on the system,
			 *  and not removed in between.
			 * Files in the directory MUST not survive reboot or a full logout/login cycle.
			 *
			 * These I might, for some specs:
			 * The directory MUST be on a local file system and not shared with any other system.
			 * The directory MUST by fully-featured by the standards of the operating system.
			 * More specifically, on Unix-like operating systems AF_UNIX sockets, symbolic links, hard links, proper permissions,
			 *  file locking, sparse files, memory mapping, file change notifications, a reliable hard link count must be supported,
			 *  and no restrictions on the file name character set should be imposed.
			 * Files in this directory MAY be subjected to periodic clean-up.
			 * To ensure that your files are not removed,
			 *  they should have their access time timestamp modified at least once every 6 hours of monotonic time or the 'sticky' bit should be set on the file.
			 *
			 * Extract from <https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html>, 2023-01-13. */
			return .success(dirPath)
		}()
	}
	
	private static func absolutePath(from envVar: String) -> FilePath? {
		guard let path = (getenv(envVar).flatMap{ FilePath(String(cString: $0)) }), path.isAbsolute else {
			return nil
		}
		return path
	}
	
	/** Always returns a non-empty array if return value is non-nil. */
	private static func absolutePaths(from envVar: String) -> [FilePath]? {
		guard let pathsStr = (getenv(envVar).flatMap{ String(cString: $0) }) else {
			return nil
		}
		let paths = pathsStr.split(separator: ":").compactMap{
			let str = String($0)
			let path = FilePath(str)
			return (path.isAbsolute ? path : nil)
		}
		return (!paths.isEmpty ? paths : nil)
	}
	
}
