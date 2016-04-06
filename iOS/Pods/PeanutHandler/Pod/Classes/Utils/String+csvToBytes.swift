//
//  String+csvToBytes.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

extension String {
    public func csvToBytes() -> [UInt8] {
        return String(self).characters.split(",").map(
            String.init).map { UInt8($0)! }
    }
    
    public func csvToIntegers() -> [Int] {
        return String(self).characters.split(",").map {
            Int(String($0)) ?? 0
        }
    }
}