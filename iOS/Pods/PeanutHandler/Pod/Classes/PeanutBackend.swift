//
//  PeanutBackend.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 02/12/2015.
//
//

import Foundation
import Alamofire

/**
 Service used for forwarding data sent by the peanut to the backend endpoint
 */
public class PeanutBackend {
    private let debugTag = "PeanutBackend"
    
    private var notificationObservers: NSMutableArray = []
    
    // MARK: Constants
    private let SenseEventsEndpoint = "https://mike.sen.se/cookie/coonut/"
    
    public init() {
//        let peanutService = PeanutService.sharedInstance()
        let peanutManager = PeanutManager.sharedInstance()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationObservers.addObject(
            notificationCenter.addObserverForName(
                PeanutManagerDidReceiveDataNotification,
                object: peanutManager,
                queue: nil) {
                    [unowned self] notification in
                    if let data = notification.userInfo![PeanutManagerNotificationPeanutDataKey] as? PeanutData {
                        let peanutHandler = notification.userInfo![PeanutManagerNotificationPeanutKey] as! PeanutHandler
                        self.handleData(peanutHandler.peanut, data: data)
                    }
            })
        
        notificationObservers.addObject(
            notificationCenter.addObserverForName(
                PeanutManagerDidConnectPeanutNotification,
                object: peanutManager,
                queue: nil) {
                    [unowned self] notification in
                    peanutLog.info("Got connected peanut, sending presence event: \(PresenceStatus.Linked)")
                    if let peanutHandler = notification.userInfo![PeanutManagerNotificationPeanutKey] as? PeanutHandler {
                        self.notifyPeanutState(peanutHandler.peanut, state: .Linked)
                    }
            }
        )
        
        notificationObservers.addObject(
            notificationCenter.addObserverForName(
                PeanutManagerDidSoftDisconnectPeanutNotification,
                object: peanutManager,
                queue: nil) {
                    [unowned self] notification in
                    peanutLog.info("Got soft disconnected peanut, sending presence event: \(PresenceStatus.Unlinked)")
                    if let peanutHandler = notification.userInfo?[PeanutManagerNotificationPeanutKey] as? PeanutHandler {
                        self.notifyPeanutState(peanutHandler.peanut, state: .Unlinked)
                    }
            }
        )
        
        notificationObservers.addObject(
            notificationCenter.addObserverForName(
                PeanutManagerDidDisconnectPeanutNotification,
                object: peanutManager,
                queue: nil) {
                    [unowned self] notification in
                    peanutLog.info("Got disconnected peanut, sending presence event: \(PresenceStatus.Absent)")
                    if let peanutHandler = notification.userInfo?[PeanutManagerNotificationPeanutKey] as? PeanutHandler {
                        self.notifyPeanutState(peanutHandler.peanut, state: .Absent)
                    }
            }
        )
    }
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        for observer in notificationObservers {
            notificationCenter.removeObserver(observer)
        }
    }
    
    private func notifyPeanutState(peanut: Peanut, state: PresenceStatus) {
        let now = NSDate()
        let presenceData = Presence(node: peanut.macAddressString ?? "unkown",
            timestamp: now, serverTimestamp: now,
            signal: peanut.rssi?.doubleValue ?? 0, status: state)
        
        let value = presenceData.serialize()
        debugPrint(value)
        Alamofire.request(.POST,
            SenseEventsEndpoint,
            parameters: value,
            encoding: .JSON)
            .response {
                request, response, data, error in
                peanutLog.info("Sent presence \(state), response code: \(response?.statusCode), error: \(error?.localizedDescription)")
        }
    }
    
    private func handleData(peanut: Peanut, data: PeanutData) {
        guard data.getType() != "unknown" && data.shouldSendToBackend()
            else {
                return
        }
        
        // TODO: Here we could check if the Peanut is ready and only send the data if
        // it is. That would avoid sending stuff like profile or ble address
        if (peanut.state != .READY) {
            peanutLog.debug("Peanut \(peanut.macAddressString ?? peanut.identifier!) not ready yet")
        }
        
        let value = data.serialize()
        peanutLog.debug("Sending data of type: \(data.getType())")
        Alamofire.request(.POST,
            SenseEventsEndpoint,
            parameters: value,
            encoding: .JSON)
            .response {
                request, response, responseData, error in
                peanutLog.info("Sent data \(data.getType()), response code: \(response?.statusCode), error: \(error?.localizedDescription ?? "None")")
        }
    }
}