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

        }
    }
    
    public func peanutManagerDidReceiveData(peanutManager: PeanutManager, peanutHandler: PeanutHandler, data: PeanutData) {
        peanutHandler.setProfile(PeanutProfileType.GenStandard)
        self.delegate?.peanutsManagerDidReceiveData!()
    }
    
    public func peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        self.delegate?.peanutsManagerDidDiscoverPeanut!(peanutManager, peanutHandler: peanutHandler)
        peanutHandler.setProfile(PeanutProfileType.GenStandard)
        self.peanutManager.connectPeanut(peanutHandler)
        
    }
    
    public func peanutManagerDidConnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        self.delegate?.connectedPeanut!()
    }
    
}

// MARK: - PeanutsManagerDelegate
@objc public protocol PeanutsManagerDelegate {
    optional func peanutsManagerDidStartScanning(peanutManager: PeanutManager)
    optional func peanutsManagerDidStopScanning(peanutManager: PeanutManager)
    optional func peanutsManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func connectedPeanut()
    optional func peanutsManagerDidReceiveData()
}