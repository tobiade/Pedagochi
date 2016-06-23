//
//  NewsFeedTableViewProtocol.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 17/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class NewsFeedMessage {
    var message: String?
    var postedAt: NSTimeInterval?
    var postedBy: String?
    var userId: String?
    var messageType: String?
    var keepItUpCount: Int?
    var doBetterCount: Int?
    var messageId: String?
    
    init(dict: AnyObject, id: String?){
        self.message = dict["message"] as? String
        self.postedAt = dict["postedAt"] as? NSTimeInterval
        self.postedBy = dict["postedBy"] as? String
        self.userId = dict["userId"] as? String
        self.messageType = dict["messageType"] as? String
        self.keepItUpCount = dict["keepItUpCount"] as? Int
        self.doBetterCount = dict["doBetterCount"] as? Int
        self.messageId = id
        
    }
}

enum MessageType: String{
    case PersonlMessage = "personalMessage"
    case BloodGlucoseUpdate = "bloodGlucoseUpdate"
}