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
    var delegate: StepTrackerDelegate?
    var movingAverage = WeightedMovingAverage(sampleSize: 10)
    
    let motionManager = CMMotionManager()
    
    init(){
        motionManager.accelerometerUpdateInterval = 0.01
    }
    
    
    func startCountingSteps(){
        var previousVector: float3?
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
             (data:CMAccelerometerData?, error:NSError?) in
            if self.firstTime == true{
               previousVector = float3(0,0,0)
                self.firstTime = false
            }
            if let currentAccelerometerData = data{
                let currentVector = self.convertAccelerationDataToVector(currentAccelerometerData.acceleration)
                let cosine = self.computeCosineOfAngle(currentVector, previousVector: previousVector!)
                //self.logger.debug(String(cosine))
                previousVector = currentVector
                self.movingAverage.addDataPoint(cosine)
                let value = self.movingAverage.calculateWeightedMovingAverage()
                self.delegate?.didStep(value)
            }
        
        })

    }
    
//    private func computeDotProductOfAcceleration(currentAcceleration: CMAcceleration, with previousAcceleration: CMAcceleration) -> Float{
//        let xValCurrent = currentAcceleration.x
//        let yValCurrent = currentAcceleration.y
//        let zValCurrent = currentAcceleration.z
//        
//        let xValPrevious: Double
//        let yValPrevious: Double
//        let zValPrevious: Double
//        
//        if firstTime == true{
//            xValPrevious = 0
//            yValPrevious = 0
//            zValPrevious = 0
//            firstTime = false
//        }else{
//            xValPrevious = previousAcceleration.x
//            yValPrevious = previousAcceleration.y
//            zValPrevious = previousAcceleration.z
//        }
//        //simd operations
//        let currentVector = float3(Float(xValCurrent), Float(yValCurrent), Float(zValCurrent))
//        let previousVector = float3(Float(xValPrevious), Float(yValPrevious), Float(zValPrevious))
//        
//        let dotProduct = dot(currentVector, previousVector)
//        
//        return dotProduct
//
//    }
    
    private func convertAccelerationDataToVector(currentAcceleration: CMAcceleration) -> float3{
        let xValCurrent = currentAcceleration.x
        let yValCurrent = currentAcceleration.y
        let zValCurrent = currentAcceleration.z
//        
//        let xValPrevious: Double
//        let yValPrevious: Double
//        let zValPrevious: Double
//        
//        if firstTime == true{
//            xValPrevious = 0
//            yValPrevious = 0
//            zValPrevious = 0
//            firstTime = false
//        }else{
//            xValPrevious = previousAcceleration.x
//            yValPrevious = previousAcceleration.y
//            zValPrevious = previousAcceleration.z
//        }
        //simd operations
        let currentVector = float3(Float(xValCurrent), Float(yValCurrent), Float(zValCurrent))
        //let previousVector = float3(Float(xValPrevious), Float(yValPrevious), Float(zValPrevious))
        
        return currentVector
        
    }
    
    func computeCosineOfAngle(currentVector: float3, previousVector: float3) -> Float{
        //finding magnitude of vector is same as finding square root of dot product of vector with itself
        let currentVectorDotProduct = dot(currentVector, currentVector)
        let currentVectorMagnitude = sqrt(currentVectorDotProduct)
        
        let previousVectorDotProduct = dot(previousVector, previousVector)
        let previousVectorMagnitude = sqrt(previousVectorDotProduct)
        
        let magnitudeMultiplication = currentVectorMagnitude * previousVectorMagnitude
        
        //compute cosine
        let accelerationDotProduct = dot(currentVector, previousVector)
        let cosineOfAngle = accelerationDotProduct/magnitudeMultiplication
        
        return cosineOfAngle
    }
}

protocol StepTrackerDelegate {
    func didStep(val: Float)
}
