//
//  ExtensionDelegate.swift
//  PedagochiWatch Extension
//
//  Created by Lanre Durosinmi-Etti on 01/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //PedagochiPhoneConnectivity.sharedInstance.startCurrentDayBGAverageUpdates()
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
       // PedagochiPhoneConnectivity.sharedInstance.startCurrentDayBGAverageUpdates()
    }

}
