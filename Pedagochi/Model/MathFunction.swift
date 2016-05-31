//
//  MathFunction.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 04/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class MathFunction {
    static let calculator = MathFunction()
    
    func calculateCumulativeAverage(newValue: Double, inout cumulativeAverage: Double, numberOfDataPoints: Int){
        //cumulative average initially 0
        cumulativeAverage = (newValue + (Double(numberOfDataPoints)*cumulativeAverage))/(Double(numberOfDataPoints) + 1)
    }
    
    func roundToDecimalPlaces(decimalPlaces: Double,value: Double) -> Double{
        let roundedNumber = round(pow(10,decimalPlaces) * value) / pow(10,decimalPlaces) //round to one decimal place
        return roundedNumber
    }
}
