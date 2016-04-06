//
//  PeanutRateController.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 17/03/16.
//
//

import Foundation

class PeanutRateController {
    private var previousPacketTimestamp: NSDate?
    var maxRate: Double  // Packets/second
    
    internal init(maxRate: Double) {
        self.maxRate = maxRate
    }
    
    // Number of packets per second
    func getPacketRate(packetDate: NSDate) -> Double? {
        if let previousPacketTimestamp = previousPacketTimestamp {
            return 1.0 / packetDate.timeIntervalSinceDate(previousPacketTimestamp)
        }
        return nil
    }
    
    func checkRateControl(packetDate: NSDate) -> Bool {
        var rateControlOk = true
        
        if let currentRate = getPacketRate(packetDate) {
            peanutLog.debug("Current rate: \(currentRate)")
            
            rateControlOk = currentRate < maxRate
        }
        
        previousPacketTimestamp = packetDate
        
        return rateControlOk
    }
}