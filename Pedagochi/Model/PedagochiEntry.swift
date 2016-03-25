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
    //var time
    //var location
    var carbs: Int?
    //var insulinUnits: Insulin?
    var mealDescription: String?
    
    init(dict: [String:AnyObject]){
       
        self.bloodGlucoseLevel = dict["bloodGlucoseLevel"] as? Double
//        self.mealDate = dict["mealDate"] as! String
//        self.mealTime = dict["mealTime"] as! String
        self.carbs = dict["carbs"] as? Int
        
        
        
    }

    
    func toAnyObject() -> [String:AnyObject?] {
        return [
            "bloodGlucoseLevel": bloodGlucoseLevel,
            "carbs": carbs,
            "mealDescription": mealDescription
        ]
    }
    
}