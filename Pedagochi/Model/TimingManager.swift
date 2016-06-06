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
    
//    func createTimerToFireAt(date: NSDate) {
//        var timer = NSTimer()
//        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(self.logging), userInfo: nil, repeats: true)
//    }
//    
//     @objc func logging(){
//        log.debug("timer fired")
//        let data: [String:AnyObject] = [
//            "infoType":["carbs_related"],
//            "userContext":["any_bg", "any_carbs"],
//            "locationContext":["anywhere"],
//            "timeContext":["anytime"],
//            "userId":FirebaseDataService.dataService.rootReference.authData.uid
//        ]
//        NetworkingManager.sharedInstance.postJSON(data)
//    }
    
    func checkIfMorning() -> Bool{
        var isMorning = false
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        
        switch hour{
        case 6..<12 :
            isMorning = true
        default:
            isMorning = false
        }
        return isMorning
    }
    
    func checkHour(againstHour: Int) -> Bool {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        
        if hour >= againstHour{
            return true
        }else{
            return false
        }

    }
}
