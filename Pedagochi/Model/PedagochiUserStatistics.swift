//
//  ContextManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 13/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import AFDateHelper
import Firebase
import XCGLogger
class PedagochiUserStatistics {
    static let sharedInstance = PedagochiUserStatistics()
    let log = XCGLogger.defaultInstance()
    
    func getAverageParameter(overThePastDays days: UInt, forKey: String, completion: (Double?, NSError?) -> Void){

        let ref = FirebaseDataService.dataService.currentUserPedagochiEntryReference
        ref.queryLimitedToLast(days).observeSingleEventOfType(.Value, withBlock: {snapshot in
            var cumulativeAverage: Double = 0
            var count: Int = 0
            for parentNode in snapshot.children.allObjects as! [FDataSnapshot]{
                for entry in parentNode.children.allObjects as! [FDataSnapshot]{
                    if let bgLevel = entry.value[forKey] as? Double{
                        MathFunction.calculator.calculateCumulativeAverage(bgLevel, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                        count += 1
                    }
                }
               
            }
            let roundedCumulativeAverage = round(10 * cumulativeAverage) / 10 //round to one decimal place
            completion(roundedCumulativeAverage,nil)
            self.log.debug("Average over the past \(days) days is \(cumulativeAverage)")
            
        })
    }
    
}