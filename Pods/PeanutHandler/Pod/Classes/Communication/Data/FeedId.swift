//
//  FeedId.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 21/12/2015.
//
//

import Foundation

/**
 Identifiers of the Peanut's feeds. Used when parsing a data packet coming from the Peanut
 */
public enum FeedId: UInt8 {
    case Empty = 0
    case Life = 1
    case Battery = 2
    case Motion = 3
    case Alert = 4
    case Temperature = 5
    case Touch = 6
    case ConnectionUpgradeStatus = 97
    case BleAddress = 98
    case System = 99
    case Presence = 100
    
    var stringValue: String {
        switch self {
        case .Empty:
            return "Empty"
        case .Life:
            return "Life"
        case .Battery:
            return "Battery"
        case .Motion:
            return "Motion"
        case .Alert:
            return "Alert"
        case .Temperature:
            return "Temperature"
        case .Touch:
            return "Touch"
        case .ConnectionUpgradeStatus:
            return "ConnectionUpgradeStatus"
        case .BleAddress:
            return "BleAddress"
        case .System:
            return "System"
        case .Presence:
            return "Presence"
        }
    }
}
