//
//  PeanutCommand.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 21/12/2015.
//
//

import Foundation

/**
 Basic protocol to encapsulate commands to send to the Peanut
 */
public protocol PeanutCommandType {
    func getBytes() -> [UInt8]
    func getData() -> NSData
}

public extension PeanutCommandType {
    static func createConfig(commandId: CommandId, extraData: [UInt8]?) -> PeanutCommandType {
        var command = PeanutCommand(commandId: commandId)
        command.extraData = extraData
        return command
    }
    
    public func getData() -> NSData {
        let bytes = getBytes()
        return NSData(bytes: bytes, length: bytes.count)
    }
}

public struct PeanutCommand: PeanutCommandType {
    var commandId: CommandId
    var extraData: [UInt8]?
    
    public init(commandId: CommandId) {
        self.commandId = commandId
        self.extraData = nil
    }
    
    public init(commandId: CommandId, extraData: [UInt8]) {
        self.commandId = commandId
        self.extraData = extraData
    }
    
    public func getBytes() -> [UInt8] {
        if let data = self.extraData {
            return [commandId.rawValue] + data
        }
        return [commandId.rawValue]
    }
}

public struct PeanutTimeCommand: PeanutCommandType {
    var commandId: CommandId
    var timestampBytes: [UInt8]
    
    init(commandId: CommandId) {
        self.commandId = commandId
        self.timestampBytes = NSDate().timeIntervalSince1970.toBytesWithMilliseconds()
    }
    
    public func getBytes() -> [UInt8] {
        return [commandId.rawValue] + timestampBytes
    }
}