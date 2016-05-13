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
import YOChartImageKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var circularImageView: WKInterfaceImage!
 //   @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    var session: WCSession!
    var bloodGlucoseAverage: String?{
        didSet{
            //bloodGlucoseLabel.setText(bloodGlucoseAverage)
            chart?.labelText = bloodGlucoseAverage
            let frame = CGRectMake(0, 0, contentFrame.width, contentFrame.height / 1.5)
            let image = chart?.drawImage(frame, scale: WKInterfaceDevice.currentDevice().screenScale)
            circularImageView.setImage(image)
        }
    }
    var chart: YODonutChartImage?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //PedagochiPhoneConnectivity.sharedInstance.setupSessionObjectWithDelegate(self)
        // PedagochiPhoneConnectivity.sharedInstance.startCurrentDayBGAverageUpdates()
            PedagochiPhoneConnectivity.sharedInstance.activate(withDelegate: self)
            PedagochiPhoneConnectivity.sharedInstance.session.sendMessage(["getCurrentDayBGAverage":true], replyHandler: nil, errorHandler: nil)
        
         chart = YODonutChartImage()
            
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
       // bloodGlucoseLabel.setText(bloodGlucoseAverage)
        
        
        chart?.donutWidth = 2
        chart?.labelText = bloodGlucoseAverage
        chart?.labelColor = UIColor.whiteColor()
        chart?.labelFont = UIFont.systemFontOfSize(20)
        chart?.values = [100]
        chart?.colors = [UIColor.whiteColor()]
        let frame = CGRectMake(0, 0, contentFrame.width, contentFrame.height / 1.5)
        let image = chart?.drawImage(frame, scale: WKInterfaceDevice.currentDevice().screenScale)
        circularImageView.setImage(image)
        //self.imageView.setImage(image)
        

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
            let watchError = error as NSError
            print(watchError.userInfo)
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let bgLevel = applicationContext["TodayBGAverage"] as? String{
            print("message received is \(bgLevel)")
            self.bloodGlucoseAverage = "\t" + bgLevel + "\r\nmmol/L"

        }
        if let uid = applicationContext["firebaseUID"] as? String {
            print("uid set")
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(uid, forKey: "firebaseUID")
        }
    }
    
}
