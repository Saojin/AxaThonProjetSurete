//
//  NSTimeInterval+toBytes.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 10/12/2015.
//
//

import Foundation

extension NSTimeInterval {
    func toBytesWithMilliseconds() -> [UInt8] {
        var intValue = Int32(self)
        let milliseconds = round((self - floor(self)) * 1000)
        let ms = UInt8(Int32(milliseconds) % UINT8_MAX)
        var bytes:[UInt8] = []
        
        while (intValue > 0) {
            let byte = intValue % (UINT8_MAX + 1)
            bytes.append(UInt8(byte))
            intValue = (intValue - byte) >> 8
        }
        
        return bytes + [ms]
    }
}