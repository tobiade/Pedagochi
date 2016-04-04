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
    //var insulinUnits: Insulin?
    var additionalDetails: String?
    
    init(dict: AnyObject){
       
        self.bloodGlucoseLevel = dict["bloodGlucoseLevel"] as? Double
        self.latitude = dict["latitude"] as? Double
        self.longitude = dict["longitude"] as? Double
        self.picture = dict["picture"] as? String
        self.date = dict["date"] as? String
        self.time = dict["time"] as? String
        self.carbs = dict["carbs"] as? Int
        self.additionalDetails = dict["additionalDetails"] as? String

        
        
        
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