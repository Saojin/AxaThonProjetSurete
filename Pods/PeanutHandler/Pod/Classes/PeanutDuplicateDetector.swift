//
//  File.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 17/03/16.
//
//

import Foundation

class PeanutDuplicateDetector {
    private var bufferSize: Int
    var timestampBuffer: [TimestampRecord] = []  // Used for deduplication
    
    init(bufferSize: Int) {
        self.bufferSize = bufferSize
    }
    
    /**
    @returns true iff packet has not already been received
    */
    func dataIsDuplicate(peanutData: PeanutData) -> Bool {
        let record = TimestampRecord(peanutData: peanutData)
        if timestampBuffer.contains(record) {
            return true
        } else {
            timestampBuffer.append(record)
            
            // TODO: remove more (half?) of the buffer to avoid doing it for each new packet after bufferSize
            if timestampBuffer.count > bufferSize {
                let toRemove = timestampBuffer.count - bufferSize
                timestampBuffer = [TimestampRecord](timestampBuffer[toRemove..<timestampBuffer.count])
            }
            return false
        }
    }
}

struct TimestampRecord: Equatable {
    var counter: UInt8
    var timestamp: NSDate
    
    init(counter: UInt8, timestamp: NSDate) {
        self.counter = counter
        self.timestamp = timestamp
    }
    
    init(peanutData: PeanutData) {
        counter = peanutData.counter!
        timestamp = peanutData.timestamp
    }
}

func ==(lhs: TimestampRecord, rhs: TimestampRecord) -> Bool {
    return lhs.counter == rhs.counter && lhs.timestamp == rhs.timestamp
}