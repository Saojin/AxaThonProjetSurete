//
//  SystemCommand.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 12/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

/**
 Commands sent by the Peanut via its "System" feed
 */
enum SystemCommand: Int {
    case Reset = 1
    case Join = 2
    case Profile = 3
    case SRAM = 4
    case Debug = 5
    case Version = 6
    case Firmware = 7
}