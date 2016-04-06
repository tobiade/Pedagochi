//
//  InterfaceController.swift
//  PedagochiWatch Extension
//
//  Created by Lanre Durosinmi-Etti on 01/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation
//import Alamofire
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    var session: WCSession!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //PedagochiPhoneConnectivity.sharedInstance.setupSessionObjectWithDelegate(self)
        // PedagochiPhoneConnectivity.sharedInstance.startCurrentDayBGAverageUpdates()
        if(WCSession.isSupported()){
            print("setting session on watch...")
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            //print("sending message...")
            //self.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)
            
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func send() {
        // sendMessageToPhone()
        //self.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)
        print("sending message...")
        //session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)
        sendContext()
        //PedagochiPhoneConnectivity.sharedInstance.startCurrentDayBGAverageUpdates()
        
        
    }
    //    func getCurrentDayBGAverage(){
    //        Alamofire.request(.GET, url).responseString(completionHandler: { response in
    //            print("Value returned is \(response.result.value)")
    //        })
    //    }
    
    //    func sendMessageToPhone(){
    //        print("sending message to iphone..")
    //        session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: { reply in
    //            let msg = reply["TodayBGAverage"] as! String
    //            print("Reply from iPhone is \(msg)")
    //
    //            dispatch_async(dispatch_get_main_queue()){
    //                self.bloodGlucoseLabel.setText(msg)
    //
    //            }
    //
    //            }, errorHandler: nil)
    //    }
    
    //    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    //        let bgLevel = message["TodayBGAverage"] as! String
    //        print("message received is \(bgLevel)")
    //        self.bloodGlucoseLabel.setText(bgLevel)
    //    }
    
    func sendContext(){
        let applicationDict = ["getCurrentDayBGAverage":true]
        do {
            try session.updateApplicationContext(applicationDict)
        } catch {
            print("error")
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let bgLevel = applicationContext["TodayBGAverage"] as? String{
            print("message received is \(bgLevel)")
            dispatch_async(dispatch_get_main_queue()) {
                self.bloodGlucoseLabel.setText(bgLevel)
            }
        }else{
            let uid = applicationContext["firebaseUID"] as? String
            FirebaseHelper.sharedInstance.uid = uid
        }
    }
    
}
