//
//  Pedometer.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 14/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreMotion

class Pedometer{
    static let sharedInstance = Pedometer()
    
    private let corePedometer = CMPedometer()

    func startPedometerUpdates(){
        // define start date
        let startDate = NSDate()
        
        // get CMPedometerData updates from startDate
        if CMPedometer.isPaceAvailable() {
            print("pedometer available")
            self.corePedometer.startPedometerUpdatesFromDate(startDate, withHandler: { (data:CMPedometerData?, error:NSError?) -> Void in
                
                if (error == nil) {
                    if let pedometerData = data{
                        print("no of steps is: \(pedometerData.numberOfSteps)")
                        var applicationDict = [String:AnyObject]()
                        applicationDict["stepCount"] = pedometerData.numberOfSteps
                        PedagochiPhoneConnectivity.sharedInstance.sendApplicationContextMessage(applicationDict)
                    }
                }
            })
        }
    }
    
}
