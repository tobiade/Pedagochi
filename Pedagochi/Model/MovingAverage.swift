//
//  MovingAverage.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 24/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import XCGLogger
class MovingAverage {
    var sampleArray = [Double]()
    var size: Int
    var count = 0
    let logger = XCGLogger.defaultInstance()
    private var previousMovingAverage: Double = 0
    init(withSize: Int){
        self.size = withSize
    }
    
    func addNewSample(sample: Double){
        let indexPosition = count % size
        sampleArray.insert(sample, atIndex: indexPosition)
        if sampleArray.count > size{
            sampleArray.removeAtIndex(indexPosition + 1)
        }
        //logger.debug("index position is - \(indexPosition)")
        count += 1
    }
    
    func calculateMovingAverage() -> Double{
        let sum: Double = sampleArray.reduce(0, combine: +)
        let currentMovingAverage: Double = sum / Double(size)
        return currentMovingAverage

        
    }
    
}