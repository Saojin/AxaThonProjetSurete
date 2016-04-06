//
//  UInt64+bytes.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 10/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

extension NSNumber {
    var bytes:[UInt8] {
        var res: [UInt8] = []
        var temp = self.unsignedLongLongValue
        while temp > 0 {
            res.append(UInt8(temp & 0xFF))
            temp = (temp - (temp & 0xFF)) >> 8
        }
        return res
    }
}

