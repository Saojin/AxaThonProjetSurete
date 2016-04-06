//
//  PeanutProfile.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 21/12/2015.
//
//

import Foundation


public enum PeanutProfileType: Int {
    // Warning: needs to be contiguous
    case GenStandard = 0
    case DoorStandard = 1
    case BedStandard = 2
    case NespressoStandard = 3
    case WalkStandard = 4
    case BottleStandard = 5
    case CubeStandard = 6
    case SweepStandard = 7
    case FridgeStandard = 8
    case TiltRealtime = 9
    case TeethStandard = 11
    case DoorHigh = 12
    case DoorVeryHigh = 13
    case SenseoStandard = 14
    case PresenceStandard = 15
    case KeurigStandard = 16
    case CoffeeStandard = 17
    case MedicationStandard = 18
    case Bootstrap = 19
    case DoorLow = 20
    case DoorVeryLow = 21
    case PresenceTemperature = 22
//    case Tilt30 = 22  TODO: Find corresponding profiles
//    case Tilt45 = 23
//    case Tilt60 = 24
//    case Test = 99
    
    public struct ProfileValue {
        public var name: String
        public var value: String
    }
    
    public var value: ProfileValue {
        switch self {
        case .GenStandard:
            return ProfileValue(name: "GenStandard", value:  "0,0,16,1,85,38,192,18,0")
        case .DoorStandard:
            return ProfileValue(name: "DoorStandard", value:  "0,1,16,43,85,38,192,18,2")
        case .DoorVeryLow:
            return ProfileValue(name: "DoorVeryLow", value: "0,21,16,70,85,38,192,18,2")
        case .DoorLow:
            return ProfileValue(name: "DoorLow", value: "0,20,16,52,85,38,192,18,2")
        case .Bootstrap:
            return ProfileValue(name: "BootStrap", value: "5,19,0,3,101,38,0,2,0")
        case .MedicationStandard:
            return ProfileValue(name: "MedicationStandard", value: "0,18,0,3,85,38,192,18,2")
        case .CoffeeStandard:
            return ProfileValue(name: "CoffeeStandard", value: "0,17,0,1,85,38,192,18,2")
        case .KeurigStandard:
            return ProfileValue(name: "KeurigStandard", value: "0,16,0,1,85,38,192,18,2")
        case .SweepStandard:
            return ProfileValue(name: "SweepStandard", value: "3,7,16,19,85,38,192,18,2")
        case .DoorHigh:
            return ProfileValue(name: "DoorHigh", value: "0,12,16,19,85,38,192,18,2")
        case .BedStandard:
            return ProfileValue(name: "BedStandard", value: "0,2,0,1,82,38,192,18,2")
        case .BottleStandard:
            return ProfileValue(name: "BottleStandard", value: "6,5,16,1,85,102,196,16,0")
        case .CubeStandard:
            return ProfileValue(name: "CubeStandard", value: "1,6,32,7,80,6,16,34,114")
        case .FridgeStandard:
            return ProfileValue(name: "FridgeStandard", value: "0,8,0,1,83,38,200,16,2")
        case .WalkStandard:
            return ProfileValue(name: "WalkStandard", value: "2,4,32,0,85,6,32,18,2")
        case .SenseoStandard:
            return ProfileValue(name: "SenseoStandard", value: "0,14,0,3,85,38,192,18,2")
        case .TiltRealtime:
            return ProfileValue(name: "TiltRealtime", value: "4,9,1,7,85,38,16,2,114")
        case .NespressoStandard:
            return ProfileValue(name: "NespressoStandard", value: "0,3,0,1,85,38,192,18,0")
        case .DoorVeryHigh:
            return ProfileValue(name: "DoorVeryHigh", value: "0,13,16,1,85,38,192,18,2")
        case .TeethStandard:
            return ProfileValue(name: "TeethStandard", value: "0,11,0,3,85,38,192,18,0")
        case .PresenceStandard:
            return ProfileValue(name: "PresenceStandard", value: "0,15,0,73,85,6,32,2,146")
        case .PresenceTemperature:
            return ProfileValue(name: "PresenceTemperature", value: "0,15,0,73,0,6,224,2,146")
//        case .Test:
//            return ProfileValue(name: "Test", value: "1,99,32,7,80,6,16,18,112")
        }
    }
    
    static func fromId(profileId: Int) -> PeanutProfileType? {
        return PeanutProfileType(rawValue: profileId)
    }
    
    public static var numberOfProfiles: Int {
        return 23
    }
}
