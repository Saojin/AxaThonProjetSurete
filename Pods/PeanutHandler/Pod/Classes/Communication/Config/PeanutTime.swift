//
//  File.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

class PeanutTime: PeanutConfig {
    required init(commandId: CommandId) {
        super.init(commandId: commandId)
        self.extraData = NSDate().timeIntervalSince1970.toBytesWithMilliseconds()
    }
}
