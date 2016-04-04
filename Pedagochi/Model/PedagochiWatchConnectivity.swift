//
//  PedagochiWatchConnectivity.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 03/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import WatchConnectivity
import XCGLogger
class PedagochiWatchConnectivity: NSObject, WCSessionDelegate {
    //logger
    let log = XCGLogger.defaultInstance()

    var session: WCSession!
    static let connectionManager = PedagochiWatchConnectivity()
    
    
    func activate(){
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
            log.debug("watch session started..")
        }
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        let command = message["getCurrentDayBGAverage"] as! Bool
        print("command received from watch is \(command)")
        
        var dict = [String:AnyObject]()
        dict["TodayBGAverage"] = "5"
        replyHandler(dict)
    }
    
    
    
    func sendMessageToWatch(){
        
    }
}