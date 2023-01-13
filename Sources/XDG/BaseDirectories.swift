/*
 * BaseDirectories.swift
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



/* We cheat a _little_ bit.
 * Doc says clearly FileManager is thread-safe.
 * I think they did not make it Sendable because:
 *  1. It’s open;
 *  2. There might be a possibility of issue with the delegate? */
extension FileManager : @unchecked Sendable {}

/* Based on <https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.8.html>. */
public struct BaseDirectories : Sendable {
	
	public enum RuntimeDirHandling {
		
		case skipSetup
		/* We ask for a handler to log something if the default value is used for the runtime directory because
		 *  the specs mandate a log should be shown somehow if the runtime dir env is not set and is needed. */
		case setup(defaultIfUndefined: FilePath?, logIfDefaultUsed: () -> Void)
		
		public static var `default`: Self {
			return .setup(defaultIfUndefined: nil, logIfDefaultUsed: { })
		}
		
	}
	
	public let fileManager: FileManager
	
	public let sharedPrefix: FilePath
	public let   userPrefix: FilePath
	
	public let   dataHome: FilePath
	public let configHome: FilePath
	public let  cacheHome: FilePath
	public let  stateHome: FilePath
	
	public let   dataDirs: [FilePath]
	public let configDirs: [FilePath]
	
	public let runtimeDir: Result<FilePath, XDGError.RuntimeDirError>
	
	/**
	 The path in which to store the binaries; should only be used by installers…
	 
	 This is always `~/.local/bin`. */
	public let binDir: Result<FilePath, XDGError>
	
	/**
	 Init a `BaseDirectories` instance by reading the environment variables and setting the different path according to the specifications.
	 
	 If set, `prefix` will be prepended to every path that is looked up.
	 If set, `profile` will be prepended in addition to the prefix for every path that is looked up, but only for user-specific directories.
	 
	 For example:
	 ```swift
	 let dirs = try BaseDirectories(prefix: "program-name", profile: "profile-name")
	 dirs.findDataFile("bar.jpg")
	 dirs.findConfigFile("foo.conf")
	 ```
	 will find `/usr/share/program-name/bar.jpg` (without `profile-name`) and and `~/.config/program-name/profile-name/foo.conf`. */
	public init(prefix: FilePath = "", profile: FilePath = "", runtimeDirHandling: RuntimeDirHandling = .default, fileManager: FileManager = .default) throws {
		let home: Result<FilePath, XDGError> = {
#if !os(tvOS) && !os(iOS) && !os(watchOS)
			guard let ret = FilePath(urlForceLocalImplementation: fileManager.homeDirectoryForCurrentUser) else {
				return .failure(Err.cannotGetHomeOfUser)
			}
			return .success(ret)
#else
			return .failure(Err.cannotGetHomeOfUser)
#endif
		}()
		
		self.fileManager = fileManager
		
		self.sharedPrefix = prefix
		self.userPrefix   = prefix.appending(profile.components)
		
		self.dataHome   = try (Self.absolutePath(from: "XDG_DATA_HOME")   ?? home.get().appending(".local/share")).lexicallyNormalized()
		self.configHome = try (Self.absolutePath(from: "XDG_CONFIG_HOME") ?? home.get().appending(".config")     ).lexicallyNormalized()
		self.cacheHome  = try (Self.absolutePath(from: "XDG_CACHE_HOME")  ?? home.get().appending(".cache")      ).lexicallyNormalized()
		self.stateHome  = try (Self.absolutePath(from: "XDG_STATE_HOME")  ?? home.get().appending(".local/state")).lexicallyNormalized()
		
		self.dataDirs   = (Self.absolutePaths(from: "XDG_DATA_DIRS")   ?? [FilePath("/usr/local/share"), FilePath("/usr/share")]).map{ $0.lexicallyNormalized() }
		self.configDirs = (Self.absolutePaths(from: "XDG_CONFIG_DIRS") ?? [FilePath("/etc/xdg")]                                ).map{ $0.lexicallyNormalized() }
		
		self.binDir = home.map{ $0.appending(".local/bin") }
		
		self.runtimeDir = {
			guard case let .setup(defaultIfUndefined: defaultPath, logIfDefaultUsed: logIfDefaultUsed) = runtimeDirHandling else {
				return .failure(.setupSkipped)
			}
			let dirPath: FilePath
			if let path = Self.absolutePath(from: "XDG_RUNTIME_DIR") {
				dirPath = path.lexicallyNormalized()
			} else {
				guard let defaultPath else {
					return .failure(.runtimeDirEnvIsUndefined)
				}
				logIfDefaultUsed()
				dirPath = defaultPath.lexicallyNormalized()
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
	
	/* If the envVar contains only colons, this will return an empty array.
	 * If envVar is empty, `nil` is returned. */
	private static func absolutePaths(from envVar: String) -> [FilePath]? {
		guard let pathsStr = (getenv(envVar).flatMap{ String(cString: $0) }), !pathsStr.isEmpty else {
			return nil
		}
		return pathsStr.split(separator: ":").compactMap{
			let str = String($0)
			let path = FilePath(str)
			return (path.isAbsolute ? path : nil)
		}
	}
	
}
