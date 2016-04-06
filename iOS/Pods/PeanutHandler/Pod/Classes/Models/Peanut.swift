//
//  peanut.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 10/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation
import CoreData
import CoreBluetooth


/**
 Class representing data about a known Peanut. The identifier is unique to the iPhone-Peanut
 pair and gathered when first discovering the Peanut. The rest is data gathered from the
 Peanut itself.
 */
public class Peanut: NSManagedObject {
    @NSManaged public var identifier: String?
    @NSManaged public var profile: String?
    @NSManaged public var address: NSNumber?
    @NSManaged public var rssi: NSNumber?
    @NSManaged public var peanutLists: NSSet?
    
    public static let entityName = "Peanut"
    public internal(set) var state: PeanutState = .DISCONNECTED
    
    public var macAddress: [UInt8]? {
        if let addrBytes = address?.bytes.reverse() {
            var paddedBytes: [UInt8] = []
            for _ in 0..<(6 - addrBytes.count) {
                paddedBytes.append(0)
            }
            return paddedBytes + addrBytes
        }
        return nil
    }
    
    public var macAddressString: String? {
        if let macAddress = macAddress {
        return (macAddress.map {
            return "\(NSNumber(unsignedChar: $0).toHexString())"}).joinWithSeparator(":")
        }
        return nil
    }
    
    public static func bytesToNSNumber(addrBytes: [NSNumber]) -> NSNumber {
        return addrBytes.bytesToNSNumber()
//        var i = -1
//        let addrValue = addrBytes.reverse().reduce(0, combine: { (val: UInt64, addrByte: NSNumber) -> UInt64 in
//            i++
//            return (addrByte.unsignedLongLongValue << UInt64(i * 8)) + val
//        })
//        return NSNumber(unsignedLongLong: addrValue)
    }
}

public enum PeanutState {
    case DISCONNECTING,
    DISCONNECTED,
    DISCOVERING_CHARACTERISTICS,
    SETTING_TIME,
    GETTING_PROFILE,
    SETTING_NOTIFICATION,
    READY,
    RECONNECTING
}


// MARK: - Data persistence
extension Peanut {
    // TODO: That's probably a shitty way of doing that
    static var managedContext: NSManagedObjectContext? {
        get {
            return PeanutManager.sharedInstance().managedObjectContext
        }
    }
    
    public static func allPeanuts() -> [Peanut]? {
        let fetchRequest = NSFetchRequest(entityName: "Peanut")
        fetchRequest.sortDescriptors?.append(
            NSSortDescriptor(key: "identifier", ascending: true))
        do {
            return try managedContext?.executeFetchRequest(fetchRequest) as? [Peanut]
        } catch {
            return nil
        }
    }
    
    static func peanutForPeripheral(peripheral: CBPeripheral) -> Peanut? {
        let fetchRequest = NSFetchRequest(entityName: "Peanut")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@",
            peripheral.identifier.UUIDString)
        do {
            let results = try managedContext?.executeFetchRequest(fetchRequest)
            if let peanut = results?.first as! Peanut? {
                return peanut
            } else {
                let peanut = NSEntityDescription.insertNewObjectForEntityForName(
                    "Peanut", inManagedObjectContext: managedContext!) as? Peanut
                peanut?.identifier = peripheral.identifier.UUIDString
                return peanut
            }
        } catch let error as NSError {
            print("Caught error \(error), \(error.userInfo)")
        }
        return nil
    }
    
    // MARK: Mac address
    static func getDeviceAddress(peripheral: CBPeripheral) -> String? {
        return peanutForPeripheral(peripheral)?.macAddressString
    }
    
    static func setDeviceAddress(peripheral: CBPeripheral, deviceAddress: [NSNumber]) {
        print("Setting address: \(deviceAddress)")
        if let peanut = peanutForPeripheral(peripheral) {
            peanut.address = deviceAddress.bytesToNSNumber()
            try! managedContext?.save()
        }
        
    }
    
    // MARK: RSSI
    static func getDeviceRssi(peripheral: CBPeripheral) -> NSNumber? {
        return peanutForPeripheral(peripheral)?.rssi
    }
    
    static func setDeviceRssi(peripheral: CBPeripheral, rssi: NSNumber) {
        if let peanut = peanutForPeripheral(peripheral) {
            managedContext?.performBlock {
                peanut.rssi = rssi
                do {
                    try managedContext?.save()
                } catch {
                    debug("Error saving rssi: \(error)", logLevel: .Error, tag: "Peanut")
                }
            }
        }
    }
    
    // MARK: Profile
    static func getDeviceProfile(peripheral: CBPeripheral) -> String? {
        return peanutForPeripheral(peripheral)?.profile
    }
    
    static func setDeviceProfile(peripheral: CBPeripheral, profile: String) {
        if let peanut = peanutForPeripheral(peripheral) {
            peanut.profile = profile
            try! managedContext?.save()
        }
    }
}