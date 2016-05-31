//
//  Keywords.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 31/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

enum Keywords: String{
    case LowBG = "low_bg"
    case HighBG = "high_bg"
    case AnyBG = "any_bg"
    case LowCarbs = "low_carbs"
    case HighCarbs = "high_carbs"
    case AnyCarbs = "any_carbs"
    case LowExercise = "low_exercise"
    case HighExercise = "high_exercise"
    case AnyExercise = "any_exercise"
    case Anywhere = "anywhere"
    case HomeLocation = "home"
    case Anytime = "anytime"
    case Morning = "morning"
    case CarbsRelated = "carbs_related"
    case ExerciseRelated = "exercise_related"
    
}

enum KeyName: String {
    case InfoType = "infoType"
    case UserContext = "userContext"
    case LocationContext = "locationContext"
    case TimeContext = "timeContext"
    case UserId = "userId"
}
