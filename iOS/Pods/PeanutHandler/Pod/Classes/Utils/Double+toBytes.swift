//
//  Double+toBytes.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

extension Double {
    func toBytes() -> [UInt8] {
        var intValue = Int64(self)
        var bytes:[UInt8] = []
        
        while (intValue > 0) {
            let byte = intValue % Int64(UINT8_MAX + 1)
            bytes.append(UInt8(byte))
            intValue = (intValue - byte) >> 8
        }
        
        return bytes
    }
}