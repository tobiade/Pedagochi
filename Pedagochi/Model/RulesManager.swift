//
//  RulesManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 16/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import GameplayKit
class RulesManager {
    
    let ruleSystem = GKRuleSystem()
    
    func buildRules(){
        PedagochiUserStatistics.sharedInstance.getAverageParameter(overThePastDays: User.sharedInstance.dataAnalysisFrequency, forKey: <#T##String#>, completion: <#T##(Double?, NSError?) -> Void#>)
    }
    
    func evaluateRules(){
        
    }
    
}