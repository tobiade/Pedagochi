//
//  NormalHealthParameters.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 16/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

enum NormalBloodGlucoseLevel {
    case LowerBound(Double)
    case UpperBound(Double)
}

enum NormalCarbsLevel {
    case LowerBound(Double)
    case UpperBound(Double)
}

enum NormalStepsPerDay {
    case RecommendedSteps(Double)
}

enum DefaultCarbsLevel: Double {
    case LowerBound = 230 //for women
    case UpperBound = 300 //for men
    //values gotten from diabetes.org.uk carbs consumtpion

}

enum DefaultBloodGlucoseLevel: Double {
    case LowerBound = 5
    case UpperBound = 8.5
    //values gotten from diabetes.co.uk normal blood sugar level ranges

}

enum DefaultStepsPerDay: Double {
    case RecommendedSteps = 10000
}

