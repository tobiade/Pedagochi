//
//  User.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 17/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class User {
    static let sharedInstance = User()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var firstName: String? = "Sarah"
    var lastName: String?
    var username: String?
    var age: Int?
    var weight: Double?
    var emailAddress: String?
    
    var addressLine1: String?{
       return userDefaults.objectForKey(ProfileSettings.AddressLine1.rawValue) as? String
    }
    var addressLine2: String?{
        return userDefaults.objectForKey(ProfileSettings.AddressLine2.rawValue) as? String
    }
    var city: String?{
        return userDefaults.objectForKey(ProfileSettings.City.rawValue) as? String
    }
    var postcode: String?{
        return userDefaults.objectForKey(ProfileSettings.Postcode.rawValue) as? String
    }
    var country: String?{
        return userDefaults.objectForKey(ProfileSettings.Country.rawValue) as? String
    }
    var lowerBG: Double?{
        if let value = userDefaults.objectForKey(ProfileSettings.MinimumBG.rawValue) as? Double{
            return value
        }else{
            return DefaultBloodGlucoseLevel.LowerBound.rawValue
        }
    }
    var upperBG: Double?{
        if let value = userDefaults.objectForKey(ProfileSettings.MaximumBG.rawValue) as? Double{
            return value
        }else{
            return DefaultBloodGlucoseLevel.UpperBound.rawValue
        }
    }
    
    
    //user settings
    var dataAnalysisFrequency: UInt = 2 //in days
    var lowerBoundBG: Double = DefaultBloodGlucoseLevel.LowerBound.rawValue
    var upperBoundBG: Double = DefaultBloodGlucoseLevel.UpperBound.rawValue
    
    var lowerBoundCarbs: Double = DefaultCarbsLevel.LowerBound.rawValue
    var upperBoundCarbs: Double = DefaultCarbsLevel.UpperBound.rawValue
    
    var stepsPerDayGoal: Double = DefaultStepsPerDay.RecommendedSteps.rawValue
    
}