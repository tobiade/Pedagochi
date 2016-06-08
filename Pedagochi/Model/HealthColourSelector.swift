//
//  HealthColourSelector.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 07/06/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import UIKit
class HealthColourSelector {
    static let sharedInstance = HealthColourSelector()
    
    func getColourForValue(value: CGFloat, lowerBG: Double, upperBG: Double) -> UIColor{
        let doubleValue = Double(value)
        if doubleValue > upperBG || doubleValue < lowerBG {
            return UIColor.redColor()
        }
        else{
            return UIColor.greenColor()
        }
    }
}