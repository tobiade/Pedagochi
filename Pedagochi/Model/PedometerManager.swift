//
//  PedometerManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 24/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import Darwin
import CoreMotion
import SigmaSwiftStatistics
import XCGLogger
class PedometerManager {
    static let sharedInstance = PedometerManager()
    let logger = XCGLogger.defaultInstance()
    let registerSize = 4
    let thresholdSampleSize = 50
    
    let motionManager: CMMotionManager
    
    var sampleCount: Int = 0
    var dynamicThresholdCount: Int = 0
    
    var xMax: Double = DBL_MIN
    var xMin: Double = DBL_MAX
    var yMax: Double = DBL_MIN
    var yMin: Double = DBL_MAX
    var zMax: Double = DBL_MIN
    var zMin: Double = DBL_MAX
    
    var xThreshold: Double = 0
    var yThreshold: Double = 0
    var zThreshold: Double = 0
    
    var xPrecision: Double = 0
    var yPrecision: Double = 0
    var zPrecision: Double = 0
    
    var xSample_new: Double = 0
    var xSample_old: Double = 0
    var ySample_new: Double = 0
    var ySample_old: Double = 0
    var zSample_new: Double = 0
    var zSample_old: Double = 0
    
    var waitForFourSamples = true
    
    var interval: Int = 0
    
    
    
    
    
    private init(){
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.02

    }
    
    
    
    func startCountingSteps(){
        let xAxisMovingAverageCalculator = MovingAverage(withSize: registerSize)
        let yAxisMovingAverageCalculator = MovingAverage(withSize: registerSize)
        let zAxisMovingAverageCalculator = MovingAverage(withSize: registerSize)
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
            (accelerometerData:CMAccelerometerData?, error:NSError?) in
            if let data = accelerometerData {
               
                
                let xAcceleration = data.acceleration.x
                let yAcceleration = data.acceleration.y
                let zAcceleration = data.acceleration.z
                xAxisMovingAverageCalculator.addNewSample(xAcceleration)
                yAxisMovingAverageCalculator.addNewSample(yAcceleration)
                zAxisMovingAverageCalculator.addNewSample(zAcceleration)
                if self.waitForFourSamples == true{
                    self.sampleCount += 1
                }
                //wait till we have 4 samples on start
                if self.sampleCount > self.registerSize{
                    self.waitForFourSamples = false
                    let xAxisAverageValue = xAxisMovingAverageCalculator.calculateMovingAverage()
                    let yAxisAverageValue = yAxisMovingAverageCalculator.calculateMovingAverage()
                    let zAxisAverageValue = zAxisMovingAverageCalculator.calculateMovingAverage()
                    
//                    self.logger.debug("Moving average \(xAxisAverageValue) - x")
//                    self.logger.debug("Moving average \(yAxisAverageValue) - y")
//                    self.logger.debug("Moving average \(zAxisAverageValue) - z")

                    
                    self.xMin = self.findMinValue(of: xAxisAverageValue, and: self.xMin)
                    self.xMax = self.findMaxValue(of: xAxisAverageValue, and: self.xMax)
                    self.yMin = self.findMinValue(of: yAxisAverageValue, and: self.yMin)
                    self.yMax = self.findMaxValue(of: yAxisAverageValue, and: self.yMax)
                    self.zMin = self.findMinValue(of: zAxisAverageValue, and: self.zMin)
                    self.zMax = self.findMaxValue(of: zAxisAverageValue, and: self.zMax)
                    
                    let xPrecisionResult = abs(xAxisAverageValue - self.xSample_new)
                    let yPrecisionResult = abs(yAxisAverageValue - self.ySample_new)
                    let zPrecisionResult = abs(zAxisAverageValue - self.zSample_new)
                    
//                    self.logger.debug("Precision \(xPrecisionResult) - x")
//                    self.logger.debug("Precision \(yPrecisionResult) - y")
//                    self.logger.debug("Precision \(zPrecisionResult) - z")
                    
                    self.xSample_old = self.xSample_new
                    if xPrecisionResult > self.xPrecision{
                        self.xSample_new = xAxisAverageValue
                    }
                    self.ySample_old = self.ySample_new
                    if yPrecisionResult > self.yPrecision{
                        self.ySample_new = yAxisAverageValue
                    }
                    self.zSample_old = self.zSample_new
                    if zPrecisionResult > self.zPrecision{
                        self.zSample_new = zAxisAverageValue
                    }
                    
                    let axisName = self.findAxisWithLargestAccelerationChange(xValue: self.xSample_new, yValue: self.ySample_new, zValue: self.zSample_new)
                    
                   // self.logger.debug(axisName)

                    switch axisName{
                    case "xAxis":
                        if self.xSample_new < self.xSample_old && self.xSample_new < self.xThreshold{
                            self.logger.debug("step - x with dynamic precision \(self.xPrecision) with threshold \(self.xThreshold) with sample_new \(self.xSample_new)")
                        }
                    case "yAxis":
                        if self.ySample_new < self.ySample_old && self.ySample_new < self.yThreshold{
                            self.logger.debug("step - y with dynamic precision \(self.yPrecision) with threshold \(self.yThreshold) with sample_new \(self.ySample_new)")
                        }
                    case "zAxis":
                        if self.zSample_new < self.zSample_old && self.zSample_new < self.zThreshold{
                            self.logger.debug("step - z with dynamic precision \(self.zPrecision) with threshold \(self.zThreshold) with sample_new \(self.zSample_new)")
                        }
                    default:
                        break
                    }
                    
                    
                }
                
                self.dynamicThresholdCount += 1
                
                if self.dynamicThresholdCount == self.thresholdSampleSize{
                    
                    self.xThreshold = self.computeDynamicThreshold(self.xMax, minValue: self.xMin)
                    self.yThreshold = self.computeDynamicThreshold(self.yMax, minValue: self.yMin)
                    self.zThreshold = self.computeDynamicThreshold(self.zMax, minValue: self.zMin)
                    
//                    self.logger.debug("Threshold \(self.xThreshold) - x")
//                    self.logger.debug("Threshold \(self.yThreshold) - y")
//                    self.logger.debug("Threshold \(self.zThreshold) - z")

                    
                    self.xPrecision = self.computeDynamicPrecision(self.xMax, minValue: self.xMin)
                    self.yPrecision = self.computeDynamicPrecision(self.yMax, minValue: self.yMin)
                    self.zPrecision = self.computeDynamicPrecision(self.zMax, minValue: self.zMin)
                    
//                    self.logger.debug("Dynamic precision \(self.xThreshold) - x")
//                    self.logger.debug("Dynamic precision \(self.yThreshold) - y")
//                    self.logger.debug("Dynamic precision \(self.zThreshold) - z")
                    
                    self.reInitialiseMaxAndMinValues()
                    self.dynamicThresholdCount = 0
                    
                }
                
            }
            
            
        })
    }
    
    private func findMinValue(of value1: Double, and value2: Double) -> Double{
        var result: Double
        if value1 < value2 {
            result = value1
        }else{
            result = value2
        }
        return result
    }
    
    private func findMaxValue(of value1: Double, and value2: Double) -> Double{
        var result: Double
        if value1 > value2 {
            result = value1
        }else{
            result = value2
        }
        return result
    }
    
    private func computeDynamicThreshold(maxValue: Double, minValue: Double) -> Double{
        let result = (maxValue + minValue)/2
        return result
    }
    
    private func reInitialiseMaxAndMinValues(){
        xMax = DBL_MIN
        xMin = DBL_MAX
        yMax = DBL_MIN
        yMin = DBL_MAX
        zMax = DBL_MIN
        zMin = DBL_MAX
    }
    
    private func computeDynamicPrecision(maxValue: Double, minValue: Double) -> Double{
        let result = abs(maxValue - minValue)
        return result
    }
    private func findAxisWithLargestAccelerationChange(xValue xValue: Double, yValue: Double, zValue: Double) -> String{
        let largest = max(max(xValue, yValue), zValue)
        let axisName: String
        switch largest{
        case xValue:
            axisName = "xAxis"
            
        case yValue:
            axisName = "yAxis"
            
        case zValue:
            axisName = "zAxis"
            
        default:
            axisName = "None"
            
        }
        return axisName
        
    }
    
}