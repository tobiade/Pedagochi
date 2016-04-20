//
//  WeightedMovingAverage.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 20/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class WeightedMovingAverage {
    var sampleSize: Int
    var valuesArray = [Float]()
    var weightsArray = [Float]()
    var count = 0
    init(sampleSize: Int){
        self.sampleSize = sampleSize
        initialiseWeights()
    }
    
    func addDataPoint(dataPoint: Float){
        //var arrayPosition = fmodf(count, sampleSize)
       
        valuesArray.insert(dataPoint, atIndex: 0)
        if valuesArray.count > sampleSize{
            valuesArray.removeLast()
        }
    }
    func initialiseWeights(){
        for index in 1...10{
            weightsArray.insert(Float(index), atIndex: 0)
        }
    }
    
    func calculateWeightedMovingAverage() -> Float{
        var numerator: Float = 0
        var denominator: Float = 0
        for index in 0..<valuesArray.count {
             numerator = weightsArray[index] * valuesArray[index] + numerator
             denominator = weightsArray[index] + denominator
        }
        let weightedMovingAverage: Float = numerator/denominator
        return weightedMovingAverage
    }
}