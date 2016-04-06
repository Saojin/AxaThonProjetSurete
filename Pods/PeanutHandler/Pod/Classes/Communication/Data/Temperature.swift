//
//  Temperature.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 04/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Represents temperature data coming from a Peanut
 */
public class Temperature: SingleValueData {
    override public var feedId: FeedId {
        return .Temperature
    }
}