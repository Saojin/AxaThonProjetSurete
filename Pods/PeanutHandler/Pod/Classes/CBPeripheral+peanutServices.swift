//
//  CBPeripheral+peanutServices.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 17/03/16.
//
//

import Foundation
import CoreBluetooth

internal extension CBPeripheral {
    var mainService: CBService? {
        guard let services = services
            else {
            return nil
        }
        
        return services.filter {
            return MAIN_SERVICE_CBUUID.isEqual($0.UUID)
            }.first
    }
    
    var commandCharacteristic: CBCharacteristic? {
        guard let mainService = mainService
            else {
                return nil
        }
        
        return mainService.characteristics?.filter {
            return WRITE_CHARACTERISTIC_CBUUID.isEqual($0.UUID)
        }.first
    }
    
    var notifyCharacteristic: CBCharacteristic? {
        guard let mainService = mainService
            else {
                return nil
        }
        
        return mainService.characteristics?.filter {
            return NOTIFY_CHARACTERISTIC_CBUUID.isEqual($0.UUID)
        }.first
    }
}