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

class PedagochiPhoneConnectivity {
    static let sharedInstance = PedagochiPhoneConnectivity()
    var session: WCSession!
//    func activate(){
//        if(WCSession.isSupported()){
//            self.session = WCSession.defaultSession()
//            self.session.activateSession()
//        }
//    }

    func setupSessionObjectWithDelegate(sessionDelegate: WCSessionDelegate){
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = sessionDelegate
            self.session.activateSession()
        }
    }
    
    func startCurrentDayBGAverageUpdates(){
        self.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)

    }
    
    func stopCurrentDayBGAverageUpdates(){
        session.sendMessage(["stopUpdates":true], replyHandler: nil, errorHandler: nil)

    }
}