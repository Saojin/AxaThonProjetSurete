//
//  Motion.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 27/10/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Represents Motion data coming from a Peanut.
 */
public class Motion: PeanutData {
    let ALGO_ANY_PROFILES = [
        "DoorVeryLow",
        "DoorLow",
        "DoorStandard",
        "DoorHigh",
        "DoorVeryHigh",
        "MedicationStandard",
        "CoffeeStandard",
        "KeurigStandard",
        "PresenceStandard",
        "SenseoStandard",
        "BedStandard",
        "GenStandard",
        "FridgeStandard",
        "NespressoStandard",
        "TeethStandard"
    ]
    
    // Use lazy property with ``[unkowned self]`` to avoid strong ref loop?
    var nbEvents: UInt32 {
        let events = Int32(body[1]) << 8 | Int32(body[0])
//        let events = Int32(dataArray![6]) << 8 | Int32(dataArray![5])
        // Adjustment method: nAdj = 3.16 * n - 27
        // with 1 <= nAdj <= 500
        if let profile = self.profile {
            if ALGO_ANY_PROFILES.contains(profile) {
                return UInt32(
                    min(
                        max(1, Int(round(3.16 * Double(events))) - 27),
                        500
                    )
                )
            }
        }
        return UInt32(events)
    }
    
    var delayEvents: UInt32 {
        return UInt32(body[3]) << 8 | UInt32(body[2])
//        return UInt32(dataArray![8]) << 8 | UInt32(dataArray![7])
    }
    
    var avgIntensity: UInt32 {
        return UInt32(body[5]) << 8 | UInt32(body[4])
//        return UInt32(dataArray![10]) << 8 | UInt32(dataArray![9])
    }
    
    // MARK: PeanutData
    public override func getData() -> NSObject {
        return serializeCsv()
    }
    
    public override var feedId: FeedId {
        return .Motion
    }
    
    private func serializeJson() -> Dictionary<String, NSObject> {
        return [
            "nbEvents": NSNumber(unsignedInt: nbEvents),
            "delayEvents": NSNumber(unsignedInt: delayEvents),
            "avgIntensity": NSNumber(unsignedInt: avgIntensity),
            "time": NSNumber(double: time)
        ]
    }
    
    private func serializeCsv() -> NSObject {
        return "\(nbEvents),\(delayEvents),\(avgIntensity)"
    }
}
