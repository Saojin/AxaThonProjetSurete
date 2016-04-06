//
//  PeanutManagerDelegateProxy.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 17/03/16.
//
//

import Foundation

/// Delegate proxy that sends NSNotifications in addition to forwarding the delegate methods to the PeanutManagerDelegate
class PeanutManagerDelegateProxy: NSObject, PeanutManagerDelegate{
    weak var delegate: PeanutManagerDelegate?
    var notificationCenter: NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    convenience init(delegate: PeanutManagerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func peanutManagerDidEnterPeanutRegion(peanutManager: PeanutManager) {
        delegate?.peanutManagerDidEnterPeanutRegion?(peanutManager)
        notificationCenter.postNotificationName(PeanutManagerDidEnterRegionNotification, object: peanutManager)
    }
    
    func peanutManagerDidExitPeanutRegion(peanutManager: PeanutManager) {
        delegate?.peanutManagerDidExitPeanutRegion?(peanutManager)
        notificationCenter.postNotificationName(PeanutManagerDidExitRegionNotification, object: peanutManager)
    }
    
    func peanutManagerDidUpdateState(peanutManager: PeanutManager) {
        delegate?.peanutManagerDidUpdateState?(peanutManager)
        notificationCenter.postNotificationName(PeanutManagerDidUpdateStateNotification, object: peanutManager)
    }
    func peanutManagerDidStartScanning(peanutManager: PeanutManager) {
        delegate?.peanutManagerDidStartScanning?(peanutManager)
        notificationCenter.postNotificationName(PeanutManagerDidStartScanningNotification, object: peanutManager)
    }
    
    func peanutManagerDidStopScanning(peanutManager: PeanutManager) {
        delegate?.peanutManagerDidStopScanning?(peanutManager)
        notificationCenter.postNotificationName(PeanutManagerDidStopScanningNotification, object: peanutManager)
    }
    
    func peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        delegate?.peanutManagerDidDiscoverPeanut?(peanutManager, peanutHandler: peanutHandler)
        notificationCenter.postNotificationName(
            PeanutManagerDidDiscoverPeanutNotification,
            object: peanutManager,
            userInfo: [PeanutManagerNotificationPeanutKey: peanutHandler])
    }
    
    func peanutManagerDidConnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        delegate?.peanutManagerDidConnectPeanut?(peanutManager, peanutHandler: peanutHandler)
        notificationCenter.postNotificationName(
            PeanutManagerDidConnectPeanutNotification,
            object: peanutManager,
            userInfo: [PeanutManagerNotificationPeanutKey: peanutHandler])
    }
    
    func peanutManagerDidReconnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        delegate?.peanutManagerDidReconnectPeanut?(peanutManager, peanutHandler: peanutHandler)
        notificationCenter.postNotificationName(
            PeanutManagerDidConnectPeanutNotification,
            object: peanutManager,
            userInfo: [PeanutManagerNotificationPeanutKey: peanutHandler, PeanutManagerNotificationIsReconnectKey: true])
    }
    
    func peanutManagerDidSoftDisconnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        delegate?.peanutManagerDidSoftDisconnectPeanut?(peanutManager, peanutHandler: peanutHandler)
        notificationCenter.postNotificationName(PeanutManagerDidSoftDisconnectPeanutNotification,
            object: peanutManager,
            userInfo: [PeanutManagerNotificationPeanutKey: peanutHandler])
    }
    
    func peanutManagerDidDisconnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        delegate?.peanutManagerDidDisconnectPeanut?(peanutManager, peanutHandler: peanutHandler)
        notificationCenter.postNotificationName(PeanutManagerDidDisconnectPeanutNotification,
            object: peanutManager,
            userInfo: [PeanutManagerNotificationPeanutKey: peanutHandler])
    }
    
    func peanutManagerDidReceiveData(peanutManager: PeanutManager, peanutHandler: PeanutHandler, data: PeanutData) {
        delegate?.peanutManagerDidReceiveData?(peanutManager, peanutHandler: peanutHandler, data: data)
        notificationCenter.postNotificationName(PeanutManagerDidReceiveDataNotification,
            object: peanutManager,
            userInfo: [PeanutManagerNotificationPeanutKey: peanutHandler, PeanutManagerNotificationPeanutDataKey: data])
    }
}