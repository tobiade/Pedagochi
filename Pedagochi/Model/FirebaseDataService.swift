//
//  FirebaseDataService.swift
//  Actibetes
//
//  Created by Sarah-Jessica Jemitola on 02/03/2016.
//  Copyright © 2016 mobilehealthcareinc. All rights reserved.
//

import Foundation
import Firebase
class FirebaseDataService {
    static let dataService = FirebaseDataService()
    //FIREBASE_ROOT_URL defined in Constants.swift file
    private var BASE_REF = Firebase(url: "\(FIREBASE_ROOT_URL)")
    private var USER_REF = Firebase(url: "\(FIREBASE_ROOT_URL)/users")
    
    
    var rootReference: Firebase {
        return BASE_REF
    }
    
    var userReference: Firebase {
        return USER_REF
    }
    
    var currentUserReference: Firebase {
        let userID = rootReference.authData.uid
        let currentUser = userReference.childByAppendingPath(userID)
        
        return currentUser!
    }
    var currentUserPedagochiEntryReference: Firebase {
        
        let reference = currentUserReference.childByAppendingPath("pedagochiEntry")
        //reference.keepSynced(true)
        return reference!
    }
    var homeReference: Firebase {
        let reference = currentUserReference.childByAppendingPath("home")
        return reference
    }
    var infoReference: Firebase {
        let reference = currentUserReference.childByAppendingPath("recommendedInformation")
        return reference
    }
    
    var newsFeedReference: Firebase {
        let reference = rootReference.childByAppendingPath("newsFeed")
        return reference
    }
    var ratedDocumentsReference: Firebase {
        let reference = currentUserReference.childByAppendingPath("ratedDocuments")
        return reference
    }
    
    var userId: String {
        let uid = rootReference.authData.uid
        return uid
    }
    
//    var currentUserRecommendationEntryReference: Firebase {
//        
//        let reference = currentUserReference.childByAppendingPath("userDeses")
//        reference.keepSynced(true)
//        return reference!
//    }
//    
//    var currentUserTipEntryReference: Firebase {
//        
//        let reference = currentUserReference.childByAppendingPath("tips")
//        reference.keepSynced(true)
//        return reference!
//    }
//    
//    var currentUserExerciseEntryReference: Firebase {
//        
//        let reference = currentUserReference.childByAppendingPath("exercise")
//        reference.keepSynced(true)
//        return reference!
//    }
    
    func addNewRatedDocument(inout dict: [String:AnyObject], sentiment: String, category: String){
        let ref = ratedDocumentsReference.childByAppendingPath(category).childByAppendingPath(sentiment).childByAutoId()
        dict["ratedDocumentEntryID"] = ref.key
        ref.setValue(dict)
        
    }
    func storeHomeCoordinates(dict: [String:AnyObject]){
        homeReference.setValue(dict)
    }
    
    func createNewUserAccount(user: [String:String], userId: String){
        let ref = userReference.childByAppendingPath(userId)
        ref.setValue(user)
    }
    
    func addNewPedagochiEntry(inout dict: [String:AnyObject], date: String){
        let ref = currentUserPedagochiEntryReference.childByAppendingPath(date).childByAutoId()
        dict["pedagochiEntryID"] = ref.key
        ref.setValue(dict)
    }
    
    func updatePedagochiEntry(dict: [String:AnyObject], withDate date: String, withID ID: String){
        let ref = currentUserPedagochiEntryReference.childByAppendingPath(date).childByAppendingPath(ID)
        ref.setValue(dict)
    }
    
    func getPedagochiEntryReferenceForDate(date: String) -> Firebase{
       let ref = currentUserPedagochiEntryReference.childByAppendingPath(date)
        return ref
        
    }
    func postNewMessage(dict: [String:AnyObject]){
        let ref = newsFeedReference.childByAutoId()
        ref.setValue(dict)
    }
    func calculateAverageBloodGlucose(overThePastDays days: UInt, withCompletionBlock: (average: Double) ->()){
        calculateAverageValueOf("bloodGlucoseLevel", overThePastDays: days, withCompletionBlock: {
            average in
                withCompletionBlock(average: average)
        })
    }
    func calculateAverageCarbsLevel(overThePastDays days: UInt, withCompletionBlock: (average: Double) ->()){
        calculateAverageValueOf("carbs", overThePastDays: days, withCompletionBlock: {
            average in
            withCompletionBlock(average: average)
        })
    }
    
    
    private func calculateAverageValueOf(key: String, overThePastDays days: UInt,withCompletionBlock: (average: Double) ->()){
        currentUserPedagochiEntryReference.queryOrderedByKey().queryLimitedToLast(days).observeSingleEventOfType(.Value, withBlock: { snapshot in
            for parentNode in snapshot.children.allObjects as! [FDataSnapshot]{
                let averageValue = self.calculateCumulativeAverageForKey(parentNode, key: key)
                withCompletionBlock(average: averageValue)
            }
        })
    }
    
    private func calculateCumulativeAverageForKey(parentNode: FDataSnapshot, key: String) -> Double{
        var cumulativeAverage: Double = 0
        var count: Int = 0
        for entry in parentNode.children.allObjects as! [FDataSnapshot]{
            
            
            //iterate over Pedagochi entries in parent date node
            if let bloodGlucose = entry.value[key] as? Double{
                //self.calculateCumulativeAverage(bloodGlucose, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                MathFunction.calculator.calculateCumulativeAverage(bloodGlucose, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                count += 1
            }

            
        }
        return cumulativeAverage
    }
    
    
}