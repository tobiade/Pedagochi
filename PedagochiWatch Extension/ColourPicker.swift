//
//  ColourPicker.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 06/06/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import WatchKit


class ColourPicker {
    static let sharedInstance = ColourPicker()
    func returnColourForBGLevel(bgLevel:String?, lowerBG: Double, upperBG: Double) -> UIColor{
        guard let bgLevelUnwrapped = bgLevel else{
            return UIColor.whiteColor()
        }
        
        let doubleValue = Double(bgLevelUnwrapped)
        print("double value is \(doubleValue)")
        if doubleValue > upperBG || doubleValue < lowerBG {
            return UIColor.redColor()
        }
        else{
            return UIColor.greenColor()
        }
    }
}