//
//  PeanutsManager.swift
//  hackathon
//
//  Created by julien hamon on 06/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import Foundation
import PeanutHandler

public class PeanutsManager: NSObject, PeanutManagerDelegate {
    let peanutManager = PeanutManager.sharedInstance()

    weak public var delegate: PeanutsManagerDelegate?
    
    override init() {
        super.init()
        self.peanutManager.delegate = self
    }
    
    func LaunchScanning()
    {
        self.peanutManager.startScanning(false)
    }
    
    func StopScanning()
    {
        self.peanutManager.stopScanning()
    }
    
    func disconnect(){
        var listPeanuts : [PeanutHandler] = peanutManager.getConnectedPeanuts()
        if listPeanuts.count > 0{
        self.peanutManager.disconnectPeanut(listPeanuts[0])
        }
    }
    
    func startBuzzer()
    {
        let command = PeanutCommand(commandId: .Buzzer)
        var listPeanuts : [PeanutHandler] = peanutManager.getConnectedPeanuts()
        if listPeanuts.count > 0{
            peanutManager.sendCommand(command, toPeanut: listPeanuts[0])
            
            let bleBuilder = PeanutBLEProfile.Builder()
            do {
               try bleBuilder.setIntervalMax(0.3)
            } catch {
                print(error)
            }
            let bleProfile = bleBuilder.build()
            listPeanuts[0].sendCommand(PeanutCommand(commandId: .SetBleProfile, extraData: bleProfile.getBytes()))

        }
    }
    
    public func peanutManagerDidReceiveData(peanutManager: PeanutManager, peanutHandler: PeanutHandler, data: PeanutData) {
        
        if(data.feedId == FeedId.Touch){
            self.delegate?.peanutsManagerTouchDetected!()
        }
    }
    
    public func peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        //self.delegate?.peanutsManagerDidDiscoverPeanut!(peanutManager, peanutHandler: peanutHandler)
        //peanutHandler.setProfile(PeanutProfileType.PresenceStandard)
        self.peanutManager.connectPeanut(peanutHandler)
        
    }
    
    public func peanutManagerDidConnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        self.delegate?.connectedPeanut!()
    }
    
    public func launchNotification (){
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        localNotification.alertBody = "Incident à l'adresse ......"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        //localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        self.startBuzzer()
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}

// MARK: - PeanutsManagerDelegate
@objc public protocol PeanutsManagerDelegate {
    optional func peanutsManagerDidStartScanning(peanutManager: PeanutManager)
    optional func peanutsManagerDidStopScanning(peanutManager: PeanutManager)
    optional func peanutsManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func connectedPeanut()
    optional func peanutsManagerTouchDetected()
}