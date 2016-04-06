//
//  File.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 14/02/16.
//
//

import Foundation

public struct MacAddress {
    public var value: Double
    
    public var longLongValue: Int64 {
        return Int64(value)
    }
    
    public var bytes: [UInt8] {
        let addrBytes = value.toBytes().reverse()
        var paddedBytes: [UInt8] = []
        for _ in 0..<(6 - addrBytes.count) {
            paddedBytes.append(0)
        }
        return paddedBytes + addrBytes
    }
    
    public var stringValue: String {
        return (bytes.map {
            return "\(NSNumber(unsignedChar: $0).toHexString())"}).joinWithSeparator(":")
    }
    
    public init(value: Double) {
        self.value = value
    }
    
    public var description: String {
        return stringValue
    }
}

extension MacAddress: Equatable {}

public func ==(lhs: MacAddress, rhs: MacAddress) -> Bool {
    return lhs.value == rhs.value
}