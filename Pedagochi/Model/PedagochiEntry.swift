//
//  PedagochiEntry.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 12/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class PedagochiEntry {
    var bloodGlucoseLevel: Double?
    var latitude: Double?
    var longitude: Double?
    var picture: String?
    var date: String?
    var time: String?
    var carbs: Int?
    var bolusInsulin: Int?
    var basalInsulin: Int?
    var additionalDetails: String?
    var entryTimeEpoch: Double?
    var pedagochiEntryID: String?
    init(dict: AnyObject){
       
        self.bloodGlucoseLevel = dict["bloodGlucoseLevel"] as? Double
        self.latitude = dict["latitude"] as? Double
        self.longitude = dict["longitude"] as? Double
        self.picture = dict["picture"] as? String
        self.date = dict["date"] as? String
        self.time = dict["time"] as? String
        self.carbs = dict["carbs"] as? Int
        self.bolusInsulin = dict["bolusInsulin"] as? Int
        self.basalInsulin = dict["basalInsulin"] as? Int
        self.additionalDetails = dict["additionalDetails"] as? String
        self.entryTimeEpoch = dict["entryTimeEpoch"] as? Double
        self.pedagochiEntryID = dict["pedagochiEntryID"] as? String
        
        
        
    }

//    
//    func toAnyObject() -> [String:AnyObject?] {
//        return [
//            "bloodGlucoseLevel": bloodGlucoseLevel,
//            "carbs": carbs,
//            "mealDescription": mealDescription
//        ]
//    }
    
}