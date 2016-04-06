//
//  PeanutConfig.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 DEPRECATED
 */
public class PeanutConfig: PeanutCommandType {
    var commandId: CommandId
    var extraData: [UInt8]?
    
    public required init(commandId: CommandId) {
        self.commandId = commandId
    }
    
    public convenience init(commandId: CommandId, extraData: [UInt8]?) {
        self.init(commandId: commandId)
        self.extraData = extraData
    }
    
    public func getBytes() -> [UInt8] {
        if let data = self.extraData {
            return [commandId.rawValue] + data
        }
        return [commandId.rawValue]
    }
    
    public func getData() -> NSData {
        let bytes = getBytes()
        return NSData(bytes: bytes, length: bytes.count)
    }
    
    // MARK: Factory method
    public static func createConfig(commandId: CommandId, extraData: [UInt8]?) -> PeanutConfig {
        if commandId == .SetTime {
            return PeanutTime(commandId: commandId)
        } else {
            let command = PeanutConfig(commandId: commandId)
            command.extraData = extraData
            return command
        }
    }
}
