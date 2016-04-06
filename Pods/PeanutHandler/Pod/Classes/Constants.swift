//
//  Constants.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 22/07/2015.
//  Copyright (c) 2015 Sen.se. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import UIKit

internal let softDisconnectionTimeout = 10.0  // Seconds
internal let peanutManagerQueueName = "se.sen"

let WRITE_CHARACTERISTIC_CBUUID = CBUUID(string: "00000000-0000-1000-8000-00805F9B34FB")
let NOTIFY_CHARACTERISTIC_CBUUID = CBUUID(string: "0000F0F3-0000-1000-8000-00805F9B34FB")

let MAIN_SERVICE_CBUUID = CBUUID(string: "0000F0F0-0000-1000-8000-00805F9B34FB")

// MARK: Profiles
// Predefined profiles
public let PROFILES = [
    "Test": "1,99,32,7,80,6,16,18,112",
    "DoorVeryLow": "0,21,16,70,85,38,192,18,2",
    "DoorLow": "0,20,16,52,85,38,192,18,2",
    "BootStrap": "5,19,0,3,101,38,0,2,0",
    "MedicationStandard": "0,18,0,3,85,38,192,18,2",
    "CoffeeStandard": "0,17,0,1,85,38,192,18,2",
    "KeurigStandard": "0,16,0,1,85,38,192,18,2",
    "SweepStandard": "3,7,16,19,85,38,192,18,2",
    "DoorHigh": "0,12,16,19,85,38,192,18,2",
    "GenStandard": "0,0,16,1,85,38,192,18,0",
    "BedStandard": "0,2,0,1,82,38,192,18,2",
    "BottleStandard": "6,5,16,1,85,102,196,16,0",
    "CubeStandard": "1,6,32,7,80,6,16,34,114",
    "FridgeStandard": "0,8,0,1,83,38,200,16,2",
    "WalkStandard": "2,4,32,0,85,6,32,18,2",
    "SenseoStandard": "0,14,0,3,85,38,192,18,2",
    "TiltRealtime": "4,9,1,7,85,38,16,2,114",
    "NespressoStandard": "0,3,0,1,85,38,192,18,0",
    "DoorStandard": "0,1,16,43,85,38,192,18,2",
    "DoorVeryHigh": "0,13,16,1,85,38,192,18,2",
    "TeethStandard": "0,11,0,3,85,38,192,18,0",
    "PresenceStandard": "0,15,0,73,85,6,32,2,146"
]
//public let PROFILE_NAMES = Array(PROFILES.keys).sort()

public let PROFILE_IDS = [
    0: "GenStandard",
    1: "DoorStandard",
    2: "BedStandard",
    3: "NespressoStandard",
    4: "WalkStandard",
    5: "BottleStandard",
    6: "CubeStandard",
    7: "SweepStandard",
    8: "FridgeStandard",
    9: "TiltRealtime",
    11: "TeethStandard",
    12: "DoorHigh",
    13: "DoorVeryHigh",
    14: "SenseoStandard",
    15: "PresenceStandard",
    16: "KeurigStandard",
    17: "CoffeeStandard",
    18: "MedicationStandard",
    19: "Bootstrap",
    20: "DoorLow",
    21: "DoorVeryLow",
    22: "Tilt30",
    23: "Tilt45",
    24: "Tilt60",
    99: "Test"
]


