//
//  Touch.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Represents data coming from the Peanut's button
 */
public class Touch: SingleValueData {
    override public var feedId: FeedId {
        return .Touch
    }
    
    public var isLongPress: Bool {
        return value == 254
    }
}