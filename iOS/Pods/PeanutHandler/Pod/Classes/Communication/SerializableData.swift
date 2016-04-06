//
//  SerializableData.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 04/02/2016.
//
//

import Foundation

let defaultIpString = "88.55.33.22"

public protocol SerializableData {
    /**
     Expected format:
     
     ```json
     {
         "ip": "127.0.0.1",
         "resource": "events",
         "method": "post",
         "auth": "CO20004A3641305",
         "body": {
            "node": "CO20004A3641305",
            "timestamp": "2014-03-19T13:47:57.000000",
            "signal": "-116",
            "value": "786,3,1,32",
            "feed_type": "motion",
            "serverTimestamp": "2014-03-19T14:21:00.402718",
            "mother_id": "MO20004A3641305"
         }
     }
     ```
    */
    func serialize() -> [String:NSObject]
    
    var auth: String { get }
    var node: String { get }
    var timestamp: NSDate { get }
    var serverTimestamp: NSDate { get }
    var signal: Double { get }
    var serializedValue: String { get }
    var feedType: String { get }
    var feedId: FeedId { get }
    var deviceId: String { get }
    var deviceName: String { get }
}


extension SerializableData {
    public var header: [String: NSObject] {
        return [
            "ip": defaultIpString,  // TODO
            "resource": "events",
            "method": "post",
            "auth": auth
        ]
    }
    
    public var body: [String: NSObject] {
        return [
            "deviceName": deviceName,
            "feed_type": feedType,
            "mother_id": deviceId,
            "node": node,
            "serverTimestamp": serverTimestamp.formatted,
            "signal": signal,
            "timestamp": timestamp.formatted,
            "value": serializedValue,
        ]
    }
    
    public func serialize() -> [String:NSObject] {
        var data = header
        data["body"] = body
        return data
    }
    
    public var feedType: String {
        var string = feedId.stringValue
        string.replaceRange(string.startIndex...string.startIndex, with: String(string[string.startIndex]).lowercaseString)
        return string
    }
    
    public var deviceId: String {
        // TODO: This identifier might change on app reinstall, try finding a way of handling that (maybe through nsuserdefaults?)
        return UIDevice.currentDevice().identifierForVendor?.UUIDString ?? deviceName
    }
    
    public var deviceName: String {
        return UIDevice.currentDevice().name
    }
}