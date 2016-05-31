//
//  RulesManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 16/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import GameplayKit
import XCGLogger
import PromiseKit

enum Fact: String{
    case BloodGlucoseHigh = "BloodGlucoseHigh"
    case BloodGlucoseLow = "BloodGlucoseLow"
    case CarbsHigh = "CarbsHigh"
    case CarbsLow = "CarbsLow"
    case StepsHigh = "StepsHigh"
    case StepsLow = "StepsLow"
}
class RulesManager {
    static let sharedInstance = RulesManager()
    
    let ruleSystem = GKRuleSystem()
    let log = XCGLogger.defaultInstance()
    
    var calculatedAverageBloodGlucoseLevel: Double?
    var calculatedAverageCarbsConsumed: Double?
    var calculatedAverageStepsTaken: Double?
    
    init(){
        createRules()
    }
    
    func buildRules(completion: (Bool?, NSError?) -> Void){
        when(getAverageBG(), getAverageCarbs(), getAverageSteps()).then { (averageBG, averageCarbs, averageSteps) -> Void in
            let roundedBG = MathFunction.calculator.roundToDecimalPlaces(1, value: averageBG)
            let roundedCarbs = MathFunction.calculator.roundToDecimalPlaces(1, value: averageCarbs)
            let roundedSteps = MathFunction.calculator.roundToDecimalPlaces(0, value: averageSteps)
            self.log.debug("\(roundedBG)mmol/L and \(roundedCarbs)g and \(roundedSteps)")

            self.calculatedAverageBloodGlucoseLevel = roundedBG
            self.calculatedAverageCarbsConsumed = roundedCarbs
            self.calculatedAverageStepsTaken = roundedSteps
            
            completion(true,nil)
            
            }.error { error in
                self.log.debug("\(error)")
                completion(nil,error as NSError)
                
        }
        
    }
    private func getAverageBG() -> Promise<Double> {
        return Promise<Double>{fulfill,reject in
            PedagochiUserStatistics.sharedInstance.getAverageParameter(overThePastDays: User.sharedInstance.dataAnalysisFrequency, forKey: PedagochiParameterNames.BloodGlucoseLevel.rawValue, completion: {result, error in
                guard error == nil else{
                    reject(error!)
                    return
                }
                fulfill(result!)
            })

            
        }
    }
    private func getAverageCarbs() -> Promise<Double> {
        return Promise<Double>{fulfill,reject in
            PedagochiUserStatistics.sharedInstance.getAverageParameter(overThePastDays: User.sharedInstance.dataAnalysisFrequency, forKey: PedagochiParameterNames.Carbs.rawValue, completion: {result, error in
                guard error == nil else{
                    reject(error!)
                    return
                }
                fulfill(result!)
            })
            
            
        }
    }
    private func getAverageSteps() -> Promise<Double>{
        return Promise<Double>{fulfill,reject in
            PedagochiUserStatistics.sharedInstance.getAverageParameter(overThePastDays: User.sharedInstance.dataAnalysisFrequency, forKey: PedagochiParameterNames.NumberOfSteps.rawValue, completion: {result, error in
                guard error == nil else{
                    reject(error!)
                    return
                }
                self.log.debug("steps are \(result)")
                fulfill(result!)
            })
            
            
        }
    }
    
    private func createRules(){
        let bgLow =  GKRule(blockPredicate: {
            system in
            if(self.calculatedAverageBloodGlucoseLevel <= User.sharedInstance.lowerBoundBG){
                return true
            }else{
                return false
            }
            }, action: { system in
                system.assertFact(Fact.BloodGlucoseLow.rawValue, grade: 1)
        })
        
        let bgHigh =  GKRule(blockPredicate: {
            system in
            if(self.calculatedAverageBloodGlucoseLevel >= User.sharedInstance.upperBoundBG){
                return true
            }else{
                return false
            }
            }, action: { system in
                system.assertFact(Fact.BloodGlucoseHigh.rawValue, grade: 1)

        })
        
        let carbsLow =  GKRule(blockPredicate: {
            system in
            if(self.calculatedAverageCarbsConsumed <= User.sharedInstance.lowerBoundCarbs){
                return true
            }else{
                return false
            }
            }, action: { system in
                system.assertFact(Fact.CarbsLow.rawValue, grade: 1)

        })
        
        let carbsHigh =  GKRule(blockPredicate: {
            system in
            if(self.calculatedAverageCarbsConsumed >= User.sharedInstance.upperBoundCarbs){
                return true
            }else{
                return false
            }
            }, action: { system in
                system.assertFact(Fact.CarbsHigh.rawValue, grade: 1)

        })
        
        let stepsTakenLow =  GKRule(blockPredicate: {
            system in
            if(self.calculatedAverageStepsTaken <= User.sharedInstance.stepsPerDayGoal){
                return true
            }else{
                return false
            }
            }, action: { system in
                system.assertFact(Fact.StepsLow.rawValue, grade: 1)

        })
        
        let stepsTakenHigh =  GKRule(blockPredicate: {
            system in
            if(self.calculatedAverageStepsTaken >= User.sharedInstance.stepsPerDayGoal){
                return true
            }else{
                return false
            }
            }, action: { system in
                system.assertFact(Fact.StepsHigh.rawValue, grade: 1)

        })
        
        ruleSystem.addRule(bgLow)
        ruleSystem.addRule(bgHigh)
        ruleSystem.addRule(carbsLow)
        ruleSystem.addRule(carbsHigh)
        ruleSystem.addRule(stepsTakenLow)
        ruleSystem.addRule(stepsTakenHigh)

    }
    private func createCarbsRules(){
        
    }
    
    func evaluateRules(){
        ruleSystem.reset()
        ruleSystem.evaluate()
    }
    
    func drawConclusions(){
        let increaseCarbs = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseLow.rawValue, Fact.CarbsLow.rawValue])
        let increaseExercise = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseHigh.rawValue, Fact.StepsLow.rawValue])
        let decreaseCarbs = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseHigh.rawValue, Fact.CarbsHigh.rawValue])
        let decreaseExercise = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseLow.rawValue, Fact.StepsHigh.rawValue])
        if increaseCarbs > 0{
            log.debug("increase carbs")
        }
        if increaseExercise > 0{
            log.debug("increase exercise")
        }
        if decreaseCarbs > 0{
            log.debug("decrease carbs")
        }
        if decreaseExercise > 0{
            log.debug("decrease exercise")
        }
    }
    func drawBGConclusions() -> String {
        let highBG = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseHigh.rawValue])
        let lowBG = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseLow.rawValue])
        var conclusion: String
        if highBG > 0{
            log.debug("high bg")
            conclusion = Keywords.HighBG.rawValue
        }else if lowBG > 0{
            log.debug("low bg")
            conclusion = Keywords.LowBG.rawValue
        }else{
            conclusion = Keywords.AnyBG.rawValue
        }
        return conclusion
        
    }
    
    func drawCarbsConclusions() -> String {
        let increaseCarbs = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseLow.rawValue, Fact.CarbsLow.rawValue])
        let decreaseCarbs = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseHigh.rawValue, Fact.CarbsHigh.rawValue])
        var conclusion: String
        if increaseCarbs > 0{
            log.debug("increase carbs")
            conclusion = Keywords.LowCarbs.rawValue
        }else if decreaseCarbs > 0{
            log.debug("decrease carbs")
            conclusion = Keywords.HighCarbs.rawValue
        }else{
            conclusion = Keywords.AnyCarbs.rawValue
        }
        return conclusion
        
    }
    func drawExerciseConclusions() -> String {
        let increaseExercise = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseHigh.rawValue, Fact.StepsLow.rawValue])
        let decreaseExercise = ruleSystem.minimumGradeForFacts([Fact.BloodGlucoseLow.rawValue, Fact.StepsHigh.rawValue])
        var conclusion: String
        if increaseExercise > 0{
            log.debug("increase exercise")
            conclusion = Keywords.LowExercise.rawValue
        }else if decreaseExercise > 0{
            log.debug("decrease exercise")
            conclusion = Keywords.HighExercise.rawValue
        }else{
            conclusion = Keywords.AnyExercise.rawValue
        }
        return conclusion
        
    }
    
}