//
//  NSNumber+toHexString.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

extension NSNumber {
    public func toHexString() -> String {
        return String(format: "%02X", self.integerValue)
    }
}