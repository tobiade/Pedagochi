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
    
}