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
import AFDateHelper
import Firebase
class PedagochiWatchConnectivity: NSObject, WCSessionDelegate {
    //logger
    let log = XCGLogger.defaultInstance()
    
    var session: WCSession!
    static let connectionManager = PedagochiWatchConnectivity()
    
    var sessionActivated = false
    var delegate: StepCounterDelegate?
    
    func activate() -> Bool{
        if(WCSession.isSupported()){
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
           checkSessionCompatibility()
            //log.debug("watch session started..")
            return true
            
        }else{
            return false
        }
    }
    
    func checkSessionCompatibility(){
        if session.paired != true{
            log.debug("apple watch not paired")
           // throw WatchError.WatchNotPaired
        }
        
        else if session.watchAppInstalled != true{
            log.debug("watchkit app not is installed")
            //throw WatchError.WatchAppNotInstalled
        }

    }
    
//    func activate(){
//        session.delegate = self
//        if sessionActivated == false{
//            session.activateSession()
//            sessionActivated = true
//        }
//    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if let command = message["getCurrentDayBGAverage"] as? Bool{
        log.debug("command received is \(command)")
        if command == true{
            print("command received")
            getCurrentBGAverageOnce()
        }
        }
        if var newEntry = message["updateBGAverage"] as? [String : AnyObject]{
            //log.debug("command received is \(command)")
            FirebaseDataService.dataService.addNewPedagochiEntry(&newEntry, date: newEntry["date"] as! String)
        }
        if let count = message["stepCount"] as? Int{
            delegate?.stepValueReceived(count)
            log.debug("count is \(count)")
        }
        //        command = message["stopUpdates"] as! Bool
        //        if command == true{
        //            removeCurrentDayBGAverageEventObserver()
        //        }
        
        
    }
    
    //    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
    //        print("Received context")
    //        var command = applicationContext["getCurrentDayBGAverage"] as! Bool
    //        log.debug("command received is \(command)")
    //        if command == true{
    //            print("command received")
    //            startSendingCurrentBGAverage()
    //        }
    //        //print(applicationContext["FlightTime"])
    //    }
    
    func sendFirebaseUserData(){
        var fireBaseDict = [String:AnyObject]()
        fireBaseDict["firebaseUID"] = FirebaseDataService.dataService.rootReference.authData.uid
        updateWatch(fireBaseDict)
    }
    
    
    
    
    func startSendingCurrentBGAverage(){
        let todaysDate = NSDate()
        let isoDate = todaysDate.toString(format: .ISO8601(ISO8601Format.Date))
        let ref = FirebaseDataService.dataService.getPedagochiEntryReferenceForDate(isoDate)
        ref.observeEventType(.Value, withBlock: {snapshot in
            var cumulativeAverage: Double = 0
            var count: Int = 0
            for entry in snapshot.children.allObjects as! [FDataSnapshot]{
                if let bgLevel = entry.value["bloodGlucoseLevel"] as? Double{
                    MathFunction.calculator.calculateCumulativeAverage(bgLevel, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                    count += 1
                }
            }
            let roundedCumulativeAverage = round(10 * cumulativeAverage) / 10 //round to one decimal place
            var dict = [String:AnyObject]()
            dict["TodayBGAverage"] = String(roundedCumulativeAverage)
            //replyHandler(dict)
            //self.session.sendMessage(dict, replyHandler: nil, errorHandler: nil)
            self.addBGBounds(&dict)
            self.updateWatch(dict)
            self.log.debug("Today's average is \(cumulativeAverage)")
            
        })
    }
    
    func getCurrentBGAverageOnce(){
        let todaysDate = NSDate()
        let isoDate = todaysDate.toString(format: .ISO8601(ISO8601Format.Date))
        let ref = FirebaseDataService.dataService.getPedagochiEntryReferenceForDate(isoDate)
        ref.observeSingleEventOfType(.Value, withBlock: {snapshot in
            var cumulativeAverage: Double = 0
            var count: Int = 0
            for entry in snapshot.children.allObjects as! [FDataSnapshot]{
                if let bgLevel = entry.value["bloodGlucoseLevel"] as? Double{
                    MathFunction.calculator.calculateCumulativeAverage(bgLevel, cumulativeAverage: &cumulativeAverage, numberOfDataPoints: count)
                    count += 1
                }
            }
            let roundedCumulativeAverage = round(10 * cumulativeAverage) / 10 //round to one decimal place
            var dict = [String:AnyObject]()
            dict["TodayBGAverage"] = String(roundedCumulativeAverage)
            //replyHandler(dict)
            //self.session.sendMessage(dict, replyHandler: nil, errorHandler: nil)
            self.addBGBounds(&dict)
            self.updateWatch(dict)
            self.log.debug("Today's average is \(cumulativeAverage)")
            
        })
    }
    
    func removeCurrentDayBGAverageEventObserver(){
        let todaysDate = NSDate()
        let isoDate = todaysDate.toString(format: .ISO8601(ISO8601Format.Date))
        let ref = FirebaseDataService.dataService.getPedagochiEntryReferenceForDate(isoDate)
        ref.removeAllObservers()
    }
    
    func updateWatch(applicationDict: [String:AnyObject]){
        do {
            try session.updateApplicationContext(applicationDict)
        } catch {
            log.debug("error: \(error)")
        }
        
    }
    
    func addBGBounds(inout dict: [String:AnyObject]){
        dict["lowerBG"] = User.sharedInstance.lowerBG
        dict["upperBG"] = User.sharedInstance.upperBG
    }
}
enum WatchError: ErrorType{
    case WatchNotPaired
    case WatchAppNotInstalled
    case WatchConnectivityNotSupported
}

protocol StepCounterDelegate{
    func stepValueReceived(stepCount: Int)
}