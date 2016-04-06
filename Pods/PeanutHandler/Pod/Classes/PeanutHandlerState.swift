//
//  PeanutHandlerState.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 17/03/16.
//
//

import Foundation
import CoreBluetooth

enum PeanutHandlerState {
    case Disconnected,
    Disconnecting,
    Connecting,
    Connected,
    DiscoveringService,
    DiscoveringCharacteristics,
    Ready
    
    init(peripheralState: CBPeripheralState) {
        switch peripheralState {
        case .Disconnected: self = .Disconnected
        case .Disconnecting: self = .Disconnecting
        case .Connecting: self = .Connecting
        case .Connected: self = .Connected
        }
    }
}