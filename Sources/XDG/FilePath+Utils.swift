/*
 * FilePath+Utils.swift
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



extension FilePath {
	
#if !canImport(System)
	init?(_ url: URL) {
		guard url.isFileURL else {
			return nil
		}
		self.init(url.path)
	}
#endif
	
	var url: URL {
		/* For now we do not consider Windows. */
#if !os(Linux)
		if #available(macOS 13.0, tvOS 16.0, iOS 16.0, watchOS 9.0, *) {
			return URL(filePath: string)
		} else {
			return URL(fileURLWithPath: string)
		}
#else
		return URL(fileURLWithPath: string)
#endif
	}
	
}
