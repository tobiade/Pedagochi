//
//  StepTrackerManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 19/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreMotion
import XCGLogger
import simd
class StepTrackerManager {
    static let sharedInstance = StepTrackerManager()
    let logger = XCGLogger.defaultInstance()
    var firstTime = true
    
    let motionManager = CMMotionManager()
    
    init(){
        motionManager.accelerometerUpdateInterval = 0.2
    }
    
    
    func startCountingSteps(){
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
            [weak self] (data:CMAccelerometerData?, error:NSError?) in
            
        })

    }
    
    func computeDotProduct(currentAcceleration: CMAcceleration, with previousAcceleration: CMAcceleration){
        let xValCurrent = currentAcceleration.x
        let yValCurrent = currentAcceleration.y
        let zValCurrent = currentAcceleration.z
        
        let xValPrevious: Double
        let yValPrevious: Double
        let zValPrevious: Double
        
        if firstTime == true{
            xValPrevious = 0
            yValPrevious = 0
            zValPrevious = 0
        }else{
            xValPrevious = previousAcceleration.x
            yValPrevious = previousAcceleration.y
            zValPrevious = previousAcceleration.z
        }
        //simd operations
        let currentVector = float3(Float(xValCurrent), Float(yValCurrent), Float(zValCurrent))
        let previousVector = float3(Float(xValPrevious), Float(yValPrevious), Float(zValPrevious))
        
        //finding magnitude of vector is same as finding square root of dot product of vector with itself
        let currentVectorDotProduct = dot(currentVector, currentVector)
        let currentVectorMagnitude = sqrt(currentVectorDotProduct)
        
        let previousVectorDotProduct = dot(previousVector, previousVector)
        let previousVectorMagnitude = sqrt(previousVectorDotProduct)
        
        
        
        let dotProduct = dot(currentVector, previousVector)
        let magnitudeMultiplication = currentVectorMagnitude * previousVectorMagnitude
        
        let cosineOfAngle = dotProduct/magnitudeMultiplication

        
        
        
    }
}
