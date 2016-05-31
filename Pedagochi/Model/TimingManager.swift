//
//  TimingManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 28/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import XCGLogger

class TimingManager {
    let log = XCGLogger.defaultInstance()
    
    static let sharedInstance = TimingManager()
    
    func createTimerToFireAt(date: NSDate) {
        var timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(self.logging), userInfo: nil, repeats: true)
    }
    
     @objc func logging(){
        log.debug("timer fired")
        let data: [String:AnyObject] = [
            "infoType":["carbs_related"],
            "userContext":["any_bg", "any_carbs"],
            "locationContext":["anywhere"],
            "timeContext":["anytime"],
            "userId":FirebaseDataService.dataService.rootReference.authData.uid
        ]
        NetworkingManager.sharedInstance.postJSON(data)
    }
}
