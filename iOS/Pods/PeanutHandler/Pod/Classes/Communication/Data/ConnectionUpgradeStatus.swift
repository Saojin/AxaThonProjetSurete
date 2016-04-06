//
//  ConnectionUpgradeStatus.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 29/02/16.
//
//

import Foundation

public class ConnectionUpgradeStatus: SingleValueData {
    override public var feedId: FeedId {
        return .ConnectionUpgradeStatus
    }
    
    override public func shouldSendToBackend() -> Bool {
        return false
    }
}
