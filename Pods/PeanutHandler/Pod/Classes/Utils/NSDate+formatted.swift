//
//  NSDate+formatted.swift
//  PomoTest
//
//  Created by Axel Colin de Verdiere on 05/11/2015.
//  Copyright © 2015 Sen.se. All rights reserved.
//

import Foundation

extension NSDate {
    struct Date {
        static let formatter = NSDateFormatter()
    }
    var formatted: String {
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return Date.formatter.stringFromDate(self)
    }
}