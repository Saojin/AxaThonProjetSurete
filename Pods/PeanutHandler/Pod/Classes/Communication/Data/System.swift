//
//  System.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 04/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

class System: PeanutData {
    // MARK: - Parsed properties
    var value: UInt32 {
        if body.count > 0 {
            return UInt32(body[0])
        }
        return 0
    }
    
    var idCommand: UInt32 {
        if body.count > 1 {
            return UInt32(body[1])
        }
        return 0
    }
    
    var dummy: UInt32 {
        if body.count > 2 {
            UInt32(body[3]) << 8 | UInt32(body[2])
        }
        return 0
    }
    
    func getProfileId() -> Int? {
        if let command = SystemCommand(rawValue: Int(idCommand)) {
            if command == .Profile {
                return Int(value)
            }
        }
        return nil
    }
    
    // MARK: - PeanutData
    override func getData() -> NSObject {
        return "\((idCommand << 8) | value),\(dummy)"
    }
    
//    override func getType() -> String {
//        return "system"
//    }
    
    override var feedId: FeedId {
        return .System
    }
}