//
//  BleAddress.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Data sent by a Peanut resulting from the GetBleAddress command and containing the MAC
 address of the Peanut.
 */
class BleAddress: PeanutData {
    private var _address: [NSNumber]?
    
    override var feedId: FeedId {
        return .BleAddress
    }
    
    override func getData() -> NSObject {
        if _address == nil {
            _address = []
            for i in body[0..<6] {
                _address!.append(NSNumber(unsignedChar: i))
            }
        }
        return _address!
    }
    
    override func shouldSendToBackend() -> Bool {
        return false
    }
    
    var macAddress: MacAddress? {
        if let address = getData() as? [NSNumber] {
            return MacAddress(value: address.bytesToNSNumber().doubleValue)
        }
        
        return nil
    }
}