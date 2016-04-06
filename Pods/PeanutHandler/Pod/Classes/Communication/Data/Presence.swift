//
//  Presence.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 04/02/2016.
//
//

import Foundation

public enum PresenceStatus: Int {
    case Absent = 0
    case Unlinked = 1
    case Linked = 2
}

public struct Presence: SerializableData {
    public var status: PresenceStatus!
    
    public var node: String
    public var timestamp: NSDate
    public var serverTimestamp: NSDate
    public var signal: Double
    
    public var auth: String {
        return node
    }
    
    public var serializedValue: String {
        return "\(status.rawValue)"
    }
    
    public let feedId = FeedId.Presence
    
    public var feedType: String {
        return feedId.stringValue
    }
    
    public init(node: String, timestamp: NSDate, serverTimestamp: NSDate, signal: Double, status: PresenceStatus) {
        self.node = node
        self.timestamp = timestamp
        self.serverTimestamp = serverTimestamp
        self.signal = signal
        self.status = status
    }
}
