//
//  HealthManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 13/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import HealthKit
import XCGLogger
class HealthManager{
    let healthKitStore: HKHealthStore = HKHealthStore()
    static let sharedInstance = HealthManager()
    
    let log = XCGLogger.defaultInstance()
    
    let stepsUnit = HKUnit.countUnit()
    let healthKitAuthorized = false
    //helper function from Ray Wenderlich
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        guard HKHealthStore.isHealthDataAvailable() == true else{
            let error = NSError(domain: "com.imperial.tobi.Pedagochi", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        var healthKitTypesToRead = Set<HKObjectType>()
        
        if let stepCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount){
            healthKitTypesToRead.insert(stepCount)
        }
        
        
        
        
        healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
    }
    
    private func getTodaySample(quantityType:HKQuantityType ,completion: (HKQuantity?, NSError?) -> Void){
            let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components: NSCalendarUnit = [.Year,.Month,.Day]
            let midnight = calendar.dateFromComponents(calendar.components(components, fromDate: now))
            let tomorrowMidnight = calendar.dateByAddingUnit(.NSDayCalendarUnit, value: 1, toDate: midnight!, options: NSCalendarOptions.init(rawValue: 0))
        
            let predicate = HKQuery.predicateForSamplesWithStartDate(midnight, endDate: tomorrowMidnight, options: .None)
        
        let dailyInterval = NSDateComponents()
        dailyInterval.day = 1
        
            let stepsQuery = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .CumulativeSum, anchorDate: midnight!, intervalComponents: dailyInterval)
        
        stepsQuery.initialResultsHandler = { query, results, error in
            if let collection = results{
                collection.enumerateStatisticsFromDate(midnight!, toDate: tomorrowMidnight!, withBlock: {
                    statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        //let sum = Int(quantity.doubleValueForUnit(HKUnit.countUnit()))
                        completion(quantity,nil)

                    }
                })
            }
        }
        
        
//        stepsQuery.statisticsUpdateHandler = { query, statistics, collection, error in
//            if let quantity = statistics?.sumQuantity(){
//               // let sum = Int(quantity.doubleValueForUnit(HKUnit.countUnit()))
//                //self.log.debug("total steps taken is \(sum)")
//                completion(quantity,nil)
//            }
//        }
            // Don't forget to execute the Query!
            healthKitStore.executeQuery(stepsQuery)
        
    }
    
    func getStepCount(completion: (Int?, NSError?) -> Void){
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        getTodaySample(stepsCount!, completion: {
            result, error in
            if let quantity = result{
                let numberOfSteps = Int(quantity.doubleValueForUnit(HealthManager.sharedInstance.stepsUnit))
                self.log.debug("step count is \(numberOfSteps)")
                completion(numberOfSteps,nil)
            }else{
                completion(nil, error)
            }
        })
    }
}