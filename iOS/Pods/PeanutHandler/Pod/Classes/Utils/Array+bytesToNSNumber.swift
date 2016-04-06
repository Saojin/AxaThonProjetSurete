//
//  Array+bytesToNSNumber.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 15/03/16.
//
//

import Foundation

extension Array where Element: NSNumber {
    /**
     Converts an array of bytes represented by NSNumbers to an NSNumber
     The size of the array must not overflow an Int64
     
     - returns: an NSNumber representing the concatenation of the whole array
     */
    func bytesToNSNumber() -> NSNumber {
        var i = -1
        let addrValue = self.reverse().reduce(0, combine: { (val: UInt64, addrByte: NSNumber) -> UInt64 in
            i += 1
            return (addrByte.unsignedLongLongValue << UInt64(i * 8)) + val
        })
        return NSNumber(unsignedLongLong: addrValue)
    }
}