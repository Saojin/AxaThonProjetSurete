//
//  Battery.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 04/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Represents battery data coming from a Peanut
 */
public class Battery: SingleValueData {
    override public var feedId: FeedId {
        return .Battery
    }
}