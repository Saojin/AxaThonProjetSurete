//
//  DataParser.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 12/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Builder class to parse raw data coming from a Peanut into a PeanutData object
 
 # Usage
 
 ```swift
 let dataParser = DataParser()
 dataParser.setData(data: receivedData)
 dataParser.setProfile("GenStandard")
 dataParser.setRSSI(-72)
 let peanutData = dataParser.getParsed()
 
 // Get as a serialized dict
 let serialized = peanutData.serialize()
 // Or
 let serialized = dataParser.getSerialized()
 ```
 */
public class DataParser {
    private var _cookieData: PeanutData?
    private var _klass: PeanutData.Type = PeanutData.self
    
    public required init() {
    }
    
    public func setData(data: NSData) {
        let dataArray = self.parseData(data)
        
        guard dataArray.count > 0
            else {
                return
        }
        
        
        switch FeedId(rawValue: dataArray.first!)! {
        case .Empty:
            peanutLog.info("Read empty data: \(dataArray)")
        case .Battery:
            self._klass = Battery.self
        case .Motion:
            self._klass = Motion.self
        case .Alert:
            self._klass = Alert.self
        case .Temperature:
            self._klass = Temperature.self
        case .Touch:
            self._klass = Touch.self
        case .BleAddress:
            self._klass = BleAddress.self
        case .System:
            self._klass = System.self
        case .ConnectionUpgradeStatus:
            self._klass = ConnectionUpgradeStatus.self
        default:
            break
        }
        
        cookieData.dataArray = dataArray
    }
    
    public func setProfile(profile: String) {
        cookieData.profile = profile
    }
    
    public func setRSSI(rssi: Double) {
        cookieData.RSSI = rssi
    }
    
    public func setMacAddress(address: String) {
        cookieData.serial = address
    }
    
    // Get product
    public func getParsed() -> PeanutData {
        return cookieData
    }
    
    public func getSerialized() -> [String:NSObject] {
        return cookieData.serialize()
    }
    
    // MARK: - Helper methods
    var cookieData: PeanutData {
        if _cookieData == nil {
            _cookieData = _klass.init()
        }
        return _cookieData!
    }
    func parseData(data: NSData) -> [UInt8] {
        let count = data.length / sizeof(UInt8)
        
        var array:[UInt8] = Array(count: count, repeatedValue: 0)
        data.getBytes(&array, length: count * sizeof(UInt8))
        
        return array
    }
}
