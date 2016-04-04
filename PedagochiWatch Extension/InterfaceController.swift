//
//  InterfaceController.swift
//  PedagochiWatch Extension
//
//  Created by Lanre Durosinmi-Etti on 01/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    let url = "https://pacific-atoll-79687.herokuapp.com/pedagochi/api/latestaverageBG"

    @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    var session: WCSession!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
 
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
            sendMessageToPhone()
        }

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getCurrentDayBGAverage(){
        Alamofire.request(.GET, url).responseString(completionHandler: { response in
            print("Value returned is \(response.result.value)")
        })
    }
    
    func sendMessageToPhone(){
        print("sending message to iphone..")
        session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: { reply in
            let msg = reply["TodayBGAverage"] as! String
            print("Reply from iPhone is \(msg)")
            
            }, errorHandler: nil)
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let bgLevel = message["bloodGlucoseLevel"] as! String
        self.bloodGlucoseLabel.setText(bgLevel)
    }

}
