//
//  String+hexToBytes.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 09/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

extension String {
    public func hexToBytes() -> [UInt8]? {
        // Inspired from http://stackoverflow.com/questions/26501276/convert-string-to-hex-string-in-swift
        // Trim & clean string
        let trimmedString = self.stringByTrimmingCharactersInSet(
            NSCharacterSet(charactersInString: "<> ")
            ).stringByReplacingOccurrencesOfString(" ", withString: ""
            ).stringByReplacingOccurrencesOfString("0x", withString: "")
        
        // Make sure there are only hex digits
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$",
            options: .CaseInsensitive)
        let found = regex.firstMatchInString(trimmedString, options: [], range: NSMakeRange(0, (trimmedString.characters.count)))
        if found == nil || (found?.range.location)! == NSNotFound || (trimmedString.characters.count) % 2 != 0 {
            return nil
        }
        
        var hexArray: [UInt8] = []
        
        var index = trimmedString.startIndex
        while index < trimmedString.endIndex {
            let nextIndex = index.successor().successor()
            let byteString = trimmedString.substringWithRange(index..<nextIndex)
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            hexArray.append(num)
            index = nextIndex
        }
        
        return hexArray
    }
}