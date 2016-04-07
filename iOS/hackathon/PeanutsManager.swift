//
//  PeanutsManager.swift
//  hackathon
//
//  Created by julien hamon on 06/04/2016.
//  Copyright © 2016 julien hamon. All rights reserved.
//

import Foundation
import PeanutHandler
import Alamofire

public class PeanutsManager: NSObject, PeanutManagerDelegate {
    let peanutManager = PeanutManager.sharedInstance()

    weak public var delegatePeanuts: PeanutsManagerDelegate?
    
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
            sendRequestForSignalements("OK")
        }
    }
    
    func sendRequestForSignalements(etat:String){
        let dic : [String : AnyObject] = ["position":["latitude":"2,2238626","longitude":" 48,8965919"],"nom": "Hamon Julien", "etat": etat]
        
        Alamofire.request(.POST, "http://team18-axasafe.azurewebsites.net/api/signalements",parameters: dic,encoding: .JSON)
            .response { request, response, data, error in
                print(request)
                print(response)
                print(NSString.init(data: data!, encoding: 1))
                print (error)
                self.delegatePeanuts?.peanutsManagerTouchDetected!()

        }
    }
    
    public func peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        //self.delegate?.peanutsManagerDidDiscoverPeanut!(peanutManager, peanutHandler: peanutHandler)
        peanutHandler.setProfile(PeanutProfileType.GenStandard)
        self.peanutManager.connectPeanut(peanutHandler)
        
    }
    
    public func peanutManagerDidConnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        //self.delegatePeanuts?.connectedPeanut!()
    }
    
    public func launchNotification (){
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
        localNotification.alertBody = "Bonjour, un incident majeur a eu lieu au sein de votre périmètre d’habitation. Merci de nous confirmer que vous êtes en sécurité."
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