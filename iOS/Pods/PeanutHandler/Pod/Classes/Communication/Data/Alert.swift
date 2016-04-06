//
//  Alert.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 27/10/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Represents alert data coming from a Peanut
 */
public class Alert: SingleValueData {
    override public var feedId: FeedId {
        return .Alert
    }
}