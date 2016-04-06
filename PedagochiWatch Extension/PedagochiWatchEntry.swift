//
//  PedagochiWatchEntry.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import WatchKit
import Alamofire
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
    
    func buildDataForStorageInFirebase() -> [String:AnyObject?]{
        var firebaseData = [String:AnyObject?]()
        addBloodGlucose(&firebaseData)
        addCarbs(&firebaseData)
        addDateAndTime(&firebaseData)
        addTimestamp(&firebaseData)
        addDevice(&firebaseData)
        return firebaseData
    }
    private func addTimestamp(inout modifyingDict: [String:AnyObject?]){
        // modifyingDict["timestamp"] = FirebaseServerValue.timestamp() //causes value event to be triggered twice
        modifyingDict["clientTimestamp"] = NSDate().timeIntervalSince1970
        
    }
    
    private func addDateAndTime(inout modifyingDict: [String:AnyObject?]){
        let time = NSDate()
        let date = time.toString(format: .ISO8601(ISO8601Format.Date))
        modifyingDict["date"] = date
        let hourMinSec = time.toString(format: .Custom("HH:mm:ss"))
        modifyingDict["time"] = hourMinSec
        modifyingDict["entryTimeEpoch"] = time.timeIntervalSince1970
    }
    
    private func addBloodGlucose(inout modifyingDict: [String:AnyObject?]){
        let val = bloodGlucoseEntryIC?.selectedBloodGlucoseLevel
        if let bloodGlucoseString = val {
            let bloodGlucoseDouble = Double(bloodGlucoseString)
            modifyingDict["bloodGlucoseLevel"] = bloodGlucoseDouble
        }else{
            modifyingDict["bloodGlucoseLevel"] = val
        }
        
    }
    private func addCarbs(inout modifyingDict: [String:AnyObject?]){
        let val = carbsEntryIC?.selectedCarbsLevel
        if let carbsString = val {
            let carbsDouble = Double(carbsString)
            modifyingDict["carbs"] = carbsDouble
        }else{
            modifyingDict["carbs"] = val
        }
   
    }
    
    func addDevice(inout modifyingDict: [String:AnyObject?]){
        modifyingDict["entryDevice"] = "Apple Watch"
    }

    
}