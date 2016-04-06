//
//  Integertype+subscript.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 10/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    subscript(index: Int) -> UInt8 {
        if index < 0 {
            return 0
        }
        return UInt8(self >> index) % 2
    }
    
    subscript(from: Int, to: Int) -> Int {
        var result = 0
        for i in from..<to {
            result += Int(self[i]) ^ i
        }
        return result
    }
    
    var bytes:[UInt8] {
        var res: [UInt8] = []
        var temp = self
        while temp > 0 {
            res.append(UInt8(temp & 0xFF))
            temp = (temp - (temp & 0xFF)) >> 8
        }
        return res
    }
}