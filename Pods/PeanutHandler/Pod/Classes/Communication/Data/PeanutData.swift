//
// PeanutData.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 27/10/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 The main object containing data sent from a Peanut. Parses the data sent from the Peanut
 and exposes it as variables. Can also output a serialized (dict) version via ``serialize()``.
 */
public class PeanutData: NSObject {
    public static let defaultIpString = "88.55.33.22"
    let DEFAULT_RSSI: Double = -116
    let DEFAULT_AUTH = "PEANUT_001"
    let DEFAULT_MOTHER_ID = "IPHONE_001"
    
    public var dataArray: [UInt8]?
    var profile: String?
    var RSSI: Double?
    var serial: String?
    
    public required override init() {
        
    }
    
    override public var description: String {
        let body = "\(getType()): \(getData())"
        if serial != nil {
            return "[\(serial!)] \(body)"
        }
        return body
    }
    
    /**
     Received format [counter, t0, t1, t2, t3]
     With timestamp bytes = [t3|t2|t1|t0]
     Return timestamp + <counter> ms (to help deduplication)
     */
    var time: Double {
        if let dataArray = dataArray {
            if dataArray.count > 4 {
                var time = (UInt32(dataArray[5]) << 24) | (UInt32(dataArray[4]) << 16)
                time |= (UInt32(dataArray[3]) << 8)
                time |= UInt32(dataArray[2])
                
                return Double(time) + (Double(counter!) / 1000.0)
            }
        }
        return 0
    }
    
    var counter: UInt8? {
        return dataArray?[1]
    }
    
    var body: [UInt8] {
        if let dataArray = dataArray where dataArray.count > 5 {
            return [UInt8](dataArray[6..<dataArray.count])
        }
        return []
    }
    
    
    public func getHeader() -> [String:NSObject] {
//        let auth = self.serial == nil ? DEFAULT_AUTH : self.serial!
        return [
            "ip": PeanutData.defaultIpString,  // TODO
            "resource": "events",
            "method": "post",
            "auth": auth
        ]
    }
    
    public func getData() -> NSObject {
        return ""
    }
    
    public func getType() -> String {
        return feedType
    }
    
    public func getTimestamp() -> NSDate {
        return NSDate(timeIntervalSince1970: Double(time) as NSTimeInterval)
    }
    
    public func shouldSendToBackend() -> Bool {
        return true
    }
    
    public var feedId: FeedId {
        return .Empty
    }
}

// MARK: - SerializableData
extension PeanutData: SerializableData {
    public var auth: String {
        return serial ?? DEFAULT_AUTH
    }
    
    public var node: String {
        return serial ?? DEFAULT_AUTH
    }
    
    public var timestamp: NSDate {
        return getTimestamp()
    }
    
    public var serverTimestamp: NSDate {
        return NSDate()
    }
    
    public var serializedValue: String {
        return "\(getData())"
    }
    
    public var signal: Double {
        return RSSI ?? DEFAULT_RSSI
    }
}