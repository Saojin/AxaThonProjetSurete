//
//  Debug.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 11/12/2015.
//
//

import Foundation
import XCGLogger

internal let peanutLog = XCGLogger.defaultInstance()

// Setup logging
func setupLogging() {
    peanutLog.setup(.Verbose, showThreadName: true, showLogLevel: true, showFileNames: true,
        showLineNumbers: true, writeToFile: nil, fileLogLevel: .Debug)
    peanutLog.xcodeColorsEnabled = true
}

enum LogLevel: String {
    case Verbose = "Verbose"
    case Debug = "Debug"
    case Info = "Info"
    case Warning = "Warning"
    case Error = "Error"
}

func debug(message: String, logLevel: LogLevel, tag: String) {
    debugPrint("[\(logLevel.rawValue)] \(tag) - \(message)")
}
