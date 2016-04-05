//
//  PedagochiWatchEntry.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

@objc protocol PedagochiEntryControllerDelegate {
    optional func setBloodGlucoseValue(value: String)
    optional func setCarbsValue(value:String)
    
}

class PedagochiWatchEntry: PedagochiEntryControllerDelegate {
    static let sharedInstance = PedagochiWatchEntry()
    
    var bloodGlucoseLevel: Double?
    var carbs: Double?
    
    func setBloodGlucoseValue(value: String) {
        let doubleValue = Double(value)
        bloodGlucoseLevel = doubleValue
    }
    func setCarbsValue(value: String) {
        let doubleValue = Double(value)
        carbs = doubleValue
    }
    
}