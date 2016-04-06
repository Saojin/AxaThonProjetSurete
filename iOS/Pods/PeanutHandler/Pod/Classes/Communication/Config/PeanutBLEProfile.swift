//
//  PeanutBLEProfile.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 08/12/2015.
//
//

import Foundation

// MARK: - Default values (in seconds)
public let minute = 60
public let defaultBleAdvertisementInterval: UInt8 = 2  // 1-10
public let defaultConnectionIntervalMax: UInt8 = 0  // Not implemented yet
public let defaultSenseAdvertisementInterval: UInt16 = UInt16(3 * minute)  // 1-65535
public let defaultSenseAdvertisementTime: UInt8 = UInt8(1 * minute)  // 1-255

public let defaultIntervalMax: UInt8 = 1
public let defaultSlaveLatency: UInt8 = 2
public let defaultConnectionTimeout: UInt8 = 5

public enum ProfileError: ErrorType {
    case ValueTooHighError
}

/**
 Encodes the command to set the BLE profile of the peanut.
 Given values of ``senseAdvertisementInterval``, ``bleAdvertisementInterval`` and
 ``senseAdvertisementTime``, a Peanut will advertise its presence with one message every
 ``1.6 * bleAdvertisementInterval`` seconds for ``senseAdvertisementTime`` seconds, then pause
 for ``bleAdvertisementInterval`` seconds.
 */
public class PeanutBLEProfile: PeanutConfig {
    var bleAdvertisementInterval: UInt8?
    var connectionIntervalMax: UInt8?
    var senseAdvertisementInterval: UInt16?
    var senseAdvertisementTime: UInt8?
    
    var intervalMax: UInt8?
    var slaveLatency: UInt8?
    var connectionTimeout: UInt8?
    
    var persist: UInt8 = 0
    
    private func computeExtraData() {
        let senseAdvInterval = senseAdvertisementInterval ?? defaultSenseAdvertisementInterval
        extraData = [
            intervalMax!,
            slaveLatency!,
            connectionTimeout!,
            bleAdvertisementInterval ?? defaultBleAdvertisementInterval,
//            connectionIntervalMax ?? defaultConnectionIntervalMax,
            UInt8(senseAdvInterval & 0xFF),
            UInt8((senseAdvInterval >> 8) & 0xFF),
            senseAdvertisementTime ?? defaultSenseAdvertisementTime,
            persist
        ]
    }
    
    public class Builder {
        private var bleProfile = PeanutBLEProfile(commandId: .SetBleProfile)
        
        public init() {
            setPersist(true)
            
            // Set default advertisement parmeteres
            bleProfile.bleAdvertisementInterval = defaultBleAdvertisementInterval
            bleProfile.senseAdvertisementInterval = defaultSenseAdvertisementInterval
            bleProfile.senseAdvertisementTime = defaultSenseAdvertisementTime
            
            // Set default connection parameters
            bleProfile.intervalMax = defaultIntervalMax
            bleProfile.slaveLatency = defaultSlaveLatency
            bleProfile.connectionTimeout = defaultConnectionTimeout
        }
        
        public func setBleAdvertisementInterval(interval: Float) throws {
            if interval > Float(UINT8_MAX) {
                throw ProfileError.ValueTooHighError
            }
            bleProfile.bleAdvertisementInterval = UInt8(interval)
        }
        
        public func setSenseAdvertisementInterval(interval: Float) throws {
            if interval > Float(UINT16_MAX) {
                throw ProfileError.ValueTooHighError
            }
            bleProfile.senseAdvertisementInterval = UInt16(interval)
        }
        
        public func setSenseAdvertisementTime(advTime: Float) throws {
            if advTime > Float(UINT8_MAX) {
                throw ProfileError.ValueTooHighError
            }
            bleProfile.senseAdvertisementTime = UInt8(advTime)
        }
        
        public func setIntervalMax(interval: Float) throws {
            if interval > Float(UINT8_MAX) {
                throw ProfileError.ValueTooHighError
            }
            bleProfile.intervalMax = UInt8(interval / (10 * 1.25))
        }
        
        public func setSlaveLatency(latency: Float) throws {
            if latency > Float(UINT8_MAX) {
                throw ProfileError.ValueTooHighError
            }
            bleProfile.slaveLatency = UInt8(latency)
        }
        
        public func setConnectionTimeout(timeout: Float) throws {
            if timeout > Float(UINT8_MAX) {
                throw ProfileError.ValueTooHighError
            }
            bleProfile.connectionTimeout = UInt8(timeout * 10)
        }
        
        public func setPersist(persist: Bool) {
            bleProfile.persist = persist ? 1: 0
        }
        
        public func build() -> PeanutBLEProfile {
            bleProfile.computeExtraData()
            return bleProfile
        }
    }
    
    // Will crash if values higher than UINT8_MAX or UINT16_MAX are given
    public static func createCommand(
        intervalMax: Double,
        slaveLatency: Int,
        connectionTimeout: Int,
        bleAdvertisementInterval: Int?,
        senseAdvertisementInterval: Int?,
        senseAdvertisementTime: Int?,
        persist: Bool?) -> PeanutBLEProfile {
            let peanutBleProfile = PeanutBLEProfile(commandId: .SetBleProfile)
            
            peanutBleProfile.intervalMax = UInt8(intervalMax / (10 * 1.25))
            peanutBleProfile.slaveLatency = UInt8(slaveLatency)
            peanutBleProfile.connectionTimeout = UInt8(connectionTimeout * 10)  // Multiplied by 10 on arrival
            
            if let bleAdvertisementInterval = bleAdvertisementInterval {
                peanutBleProfile.bleAdvertisementInterval = UInt8(bleAdvertisementInterval)
            }
            if let senseAdvertisementInterval = senseAdvertisementInterval {
                peanutBleProfile.senseAdvertisementInterval = UInt16(senseAdvertisementInterval)
            }
            if let senseAdvertisementTime = senseAdvertisementTime {
                peanutBleProfile.senseAdvertisementTime = UInt8(senseAdvertisementTime)
            }
            peanutBleProfile.persist = (persist ?? false) ? 1 : 0
            
            peanutBleProfile.computeExtraData()
            
            return peanutBleProfile
    }
}