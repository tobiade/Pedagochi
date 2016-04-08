//
//  FirebaseHelper.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 06/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import Alamofire
class FirebaseHelper {
    static let sharedInstance = FirebaseHelper()
    
    var uid: String?
    
    let userReference = "https://brilliant-torch-960.firebaseio.com/users/"
    
    init(){
        let defaults = NSUserDefaults.standardUserDefaults()
        uid = defaults.stringForKey("firebaseUID")
    }
    
    func persistEntryToFirebase(dict:[String:AnyObject]){
        let pedagochiUserRef = userReference.stringByAppendingString(uid!)
        let currentDate = NSDate()
        let isoDate = currentDate.toString(format: .ISO8601(ISO8601Format.Date))
        let pedagochiEntryref = pedagochiUserRef.stringByAppendingString("/pedagochiEntry/\(isoDate).json")
        print("url is \(pedagochiEntryref)")
        Alamofire.request(.POST, pedagochiEntryref, parameters: dict, encoding: .JSON ).responseString(completionHandler: { response in
            print("Value returned is \(response.result.value)")
        })
    }
}

