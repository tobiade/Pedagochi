//
//  ContextBuilder.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 31/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import XCGLogger
class ContextBuilder {
    let log = XCGLogger.defaultInstance()
    static let sharedInstance = ContextBuilder()
    
    func genericCarbsRelatedContext(completion: ([String: AnyObject]?, NSError?) -> Void){
        RulesManager.sharedInstance.buildRules({
            success, error in
            if success == true{
                RulesManager.sharedInstance.evaluateRules()

               let bgConclusion =  RulesManager.sharedInstance.drawBGConclusions()
               let carbsConclusion = RulesManager.sharedInstance.drawCarbsConclusions()
                let userContext = [bgConclusion, carbsConclusion]
                let locationContext = [Keywords.Anywhere.rawValue]
                let timeContext = [Keywords.Anytime.rawValue]
                let infoType = [Keywords.CarbsRelated.rawValue]
                var context = [String: AnyObject]()
                context[KeyName.InfoType.rawValue] = infoType
                context[KeyName.UserContext.rawValue] = userContext
                context[KeyName.LocationContext.rawValue] = locationContext
                context[KeyName.TimeContext.rawValue] = timeContext
                context[KeyName.UserId.rawValue] = FirebaseDataService.dataService.userId
                self.log.debug(context.debugDescription)
                completion(context,nil)
            }
        })

    }
    func genericExerciseContext(completion: ([String: AnyObject]?, NSError?) -> Void){
        RulesManager.sharedInstance.buildRules({
            success, error in
            if success == true{
                RulesManager.sharedInstance.evaluateRules()
                
                let bgConclusion =  RulesManager.sharedInstance.drawBGConclusions()
                let exerciseConclusion = RulesManager.sharedInstance.drawExerciseConclusions()
                let userContext = [bgConclusion, exerciseConclusion]
                let locationContext = [Keywords.Anywhere.rawValue]
                let timeContext = [Keywords.Anytime.rawValue]
                let infoType = [Keywords.ExerciseRelated.rawValue]
                var context = [String: AnyObject]()
                context[KeyName.InfoType.rawValue] = infoType
                context[KeyName.UserContext.rawValue] = userContext
                context[KeyName.LocationContext.rawValue] = locationContext
                context[KeyName.TimeContext.rawValue] = timeContext
                context[KeyName.UserId.rawValue] = FirebaseDataService.dataService.userId
                completion(context,nil)
            }
        })
        
    }
    
    func leavingHomeLocationContext(completion: ([String: AnyObject]?, NSError?) -> Void){
        RulesManager.sharedInstance.buildRules({
            success, error in
            if success == true{
                RulesManager.sharedInstance.evaluateRules()
                
                let bgConclusion =  RulesManager.sharedInstance.drawBGConclusions()
                let carbsConclusion = RulesManager.sharedInstance.drawCarbsConclusions()
                let userContext = [bgConclusion, carbsConclusion]
                let locationContext = [Keywords.HomeLocation.rawValue]
                let timeContext = [Keywords.Morning.rawValue]
                let infoType = [Keywords.CarbsRelated.rawValue]
                var context = [String: AnyObject]()
                context[KeyName.InfoType.rawValue] = infoType
                context[KeyName.UserContext.rawValue] = userContext
                context[KeyName.LocationContext.rawValue] = locationContext
                context[KeyName.TimeContext.rawValue] = timeContext
                context[KeyName.UserId.rawValue] = FirebaseDataService.dataService.userId
                completion(context,nil)
            }
        })
        
    }
}