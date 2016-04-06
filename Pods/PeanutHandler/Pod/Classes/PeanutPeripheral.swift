//
//  PeanutPeripheral.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 10/12/2015.
//
//

import Foundation
import CoreBluetooth

protocol PeanutPeripheral: Equatable {
    var identifier: NSUUID { get }
    var delegate: CBPeripheralDelegate? { get set }
    var name: String? { get }
    var RSSI: NSNumber? { get }
    var state: CBPeripheralState { get }
    var services: [CBService]? { get }
    func readRSSI()
    func discoverServices(serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(characteristicUUIDs: [CBUUID]?, forService service: CBService)
    func readValueForCharacteristic(characteristic: CBCharacteristic)
    func writeValue(data: NSData, forCharacteristic characteristic: CBCharacteristic, type: CBCharacteristicWriteType)
    func setNotifyValue(enabled: Bool, forCharacteristic characteristic: CBCharacteristic)
}

extension CBPeripheral: PeanutPeripheral {
}
