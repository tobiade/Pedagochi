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
    
    var delegates = [TodayUserDataChangeDelegate]()
    
    func getAverageParameter(overThePastDays days: UInt, forKey: String, completion: (Double?, NSError?) -> Void){

        let ref = FirebaseDataService.dataService.currentUserPedagochiEntryReference
        ref.queryOrderedByKey().queryLimitedToLast(days).observeSingleEventOfType(.Value, withBlock: {snapshot in
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
            completion(cumulativeAverage,nil)
            self.log.debug("Average \(forKey) over the past \(days) days is \(cumulativeAverage)")
            
        })
    }
    
    func listenOnUSerDataForDate(date: NSDate){
        let isoDate = date.toString(format: .ISO8601(ISO8601Format.Date))
        let ref = FirebaseDataService.dataService.getPedagochiEntryReferenceForDate(isoDate)
        ref.observeEventType(.Value, withBlock: {snapshot in
            
                for delegate in self.delegates{
                    delegate.dataDidChange(snapshot)
                }
        
        })
    }
    
 
}

protocol TodayUserDataChangeDelegate{
    func dataDidChange(snapshot:FDataSnapshot)
}