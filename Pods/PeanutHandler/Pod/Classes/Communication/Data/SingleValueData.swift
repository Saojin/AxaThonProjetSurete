//
//  SingleValueData.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 04/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

public class SingleValueData: PeanutData {
//    public var type: String = "default"
    
    public var value: UInt32 {  // UInt32
//        if dataArray!.count > 6 {
//            return UInt32(dataArray![6]) << 8 | UInt32(dataArray![5])
//        } else {
//            return UInt32(dataArray![5])
//        }
        if body.count > 1 {
            return UInt32(body[1]) << 8 | UInt32(body[0])
        } else {
            return UInt32(body[0])
        }
    }
    
    // MARK: CookieData
    public override func getData() -> NSObject {
        return NSNumber(unsignedInt: value)
    }
    
//    public override func getType() -> String {
//        return type
//    }
}