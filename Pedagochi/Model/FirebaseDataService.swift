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
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
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
    
    func createNewUserAccount(user: [String:String]){
        currentUserReference.setValue(user)
    }
    
    func addNewPedagochiEntry(dict: [String:AnyObject], date: String){
        currentUserPedagochiEntryReference.childByAppendingPath(date).childByAutoId().setValue(dict)
    }
    
}