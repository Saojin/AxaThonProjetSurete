//
//  CommandId.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 21/12/2015.
//
//

import Foundation

/**
 Commands that can be sent to the Peanut via its Write characteristics (except for
 ``.NotifyAck`` that is sent to its Notify characteristic)
 */
public enum CommandId: UInt8 {
    case SetTime = 1
    case SetProfile = 2
    case SetBleProfile = 3
    case GetTime = 4
    case GetProfileHash = 5
    case GetBattery  = 6
    case GetTemperature = 7
    case GetBleAddress = 8
    case Buzzer = 9
    case ConnectionUpgradeStatus = 100
    case AdvertisementStfu = 101
    case NotifyAck = 254
}