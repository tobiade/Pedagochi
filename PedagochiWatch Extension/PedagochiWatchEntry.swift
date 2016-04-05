//
//  PedagochiWatchEntry.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import WatchKit
@objc protocol PedagochiEntryControllerDelegate {
    optional func setBloodGlucoseValue(value: String)
    optional func setCarbsValue(value:String)
    
}

class PedagochiWatchEntry: PedagochiEntryControllerDelegate {
    static let sharedInstance = PedagochiWatchEntry()
    
    //reference to interface controllers
    var bloodGlucoseEntryIC: BloodGlucoseEntryInterfaceController?
    var carbsEntryIC: CarbsEntryInterfaceController?
    
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
    
    func persistEntryToFirebase(){
       let bg = bloodGlucoseEntryIC?.selectedBloodGlucoseLevel
        let carbs = carbsEntryIC?.selectedCarbsLevel
        
        print("BG is \(bg) and carbs is \(carbs)")
    }
    
}