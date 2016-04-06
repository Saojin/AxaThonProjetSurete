//
//  PeanutManagerConstants.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 12/02/16.
//
//

import Foundation
import CoreBluetooth

// MARK: - Private constants
let centralManagerRestorationIdentifier = "PeanutCentralManager"
let notifyServiceCBUUID = CBUUID(string: "0000F0F0-0000-1000-8000-00805F9B34FB")
let mainServiceCBUUID = notifyServiceCBUUID
let proximityUUIDString = "C50A0049-0062-FE57-6B55-25F9AF6E46F8" // Peanut Proto
let peanutBeaconIdentifier = "CookieV2"

// MARK: - Notifications
// Sent whenever the underlying CBCentralManager object updates its state
public let PeanutManagerDidUpdateStateNotification = "PeanutManagerDidUpdateState"
public let PeanutManagerDidStartScanningNotification = "PeanutManagerDidStartScanning"
public let PeanutManagerDidStopScanningNotification = "PeanutManagerDidStopScanning"

// iBeacon-related notifications
public let PeanutManagerDidEnterRegionNotification = "PeanutManagerDidEnterRegion"
public let PeanutManagerDidExitRegionNotification = "PeanutManagerDidExitRegion"

/**
 Sent whenever a new Peanut is discovered. Contains the discovered ``Peanut`` object
 in ``notification.userInfo`` with the key NotificationPeanutKey.
 */
public let PeanutManagerDidDiscoverPeanutNotification = "PeanutManagerDidDiscoverPeanut"
/**
 Keys: NotificationPeanutKey
 */
public let PeanutManagerDidConnectPeanutNotification = "PeanutManagerDidConnectPeanut"
/**
 Keys: NotificationPeanutKey
 */
public let PeanutManagerDidSoftDisconnectPeanutNotification = "PeanutManagerDidSoftDisconnectPeanut"
/**
 Keys: NotificationPeanutKey
 */
public let PeanutManagerDidDisconnectPeanutNotification = "PeanutManagerDidDisconnectPeanut"
/**
 Keys:
    - NotificationPeanutKey
    - NotificationPeanutDataKey
 */
public let PeanutManagerDidReceiveDataNotification = "PeanutManagerDidReceiveData"

/**
 Keys:
    - NotificationPeanutKey
    - (Optional) NotificationPeanutDataKey
 */
public let PeanutManagerReceivedDuplicatePacketNotification = "PeanutManagerReceivedDuplicatePacket"

// MARK: Notification keys
/**
 Maps to a ``Peanut`` object
 */
public let PeanutManagerNotificationPeanutKey = "Peanut"
/**
 Maps to a ``CookieData`` object
 */
public let PeanutManagerNotificationPeanutDataKey = "PeanutData"

public let PeanutManagerNotificationIsReconnectKey = "IsReconnect"