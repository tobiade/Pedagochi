//
//  PedagochiPhoneConnectivity.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 04/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class PedagochiPhoneConnectivity: NSObject, WCSessionDelegate {
    static let sharedInstance = PedagochiPhoneConnectivity()
    var session: WCSession!
    var bgUpdateDelegate: PedagochiParameterUpdateDelegate?
    

    func activate() {
        if(WCSession.isSupported()){
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            print("watch session started..")
        }
    }
    
    
    func startCurrentDayBGAverageUpdates(){
        self.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)

    }
    
    func stopCurrentDayBGAverageUpdates(){
        session.sendMessage(["stopUpdates":true], replyHandler: nil, errorHandler: nil)

    }
    func sendApplicationContextMessage(applicationDict: [String:AnyObject]){
        do {
            try session.updateApplicationContext(applicationDict)
        } catch {
            print("error")
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let bgLevel = applicationContext["TodayBGAverage"] as? String{
            print("message received is \(bgLevel)")
            bgUpdateDelegate?.bloodGlucoseAverageUpdate(bgLevel)
            
        }
        if let uid = applicationContext["firebaseUID"] as? String {
            print("uid set")
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(uid, forKey: "firebaseUID")
        }
    }
}
enum WatchError: ErrorType{
    case WatchNotPaired
    case WatchAppNotInstalled
    case WatchConnectivityNotSupported
}

protocol PedagochiParameterUpdateDelegate{
    func bloodGlucoseAverageUpdate(value: String)
}