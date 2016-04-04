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
    let url = "https://pacific-atoll-79687.herokuapp.com/pedagochi/api/latestaverageBG"

    @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    var session: WCSession!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("awake with context called")
       // PedagochiPhoneConnectivity.sharedInstance.setupSessionObjectWithDelegate(self)
        //PedagochiPhoneConnectivity.sharedInstance.startCurrentDayBGAverageUpdates()
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
            print("sending message...")
            self.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)

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
        self.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)


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
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let bgLevel = message["TodayBGAverage"] as! String
        print("message received is \(bgLevel)")
        self.bloodGlucoseLabel.setText(bgLevel)
    }

}
