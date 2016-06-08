//
//  AppDelegate.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 12/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import XCGLogger
import WatchConnectivity
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RegionEventDelegate {
    //logger
    let log = XCGLogger.defaultInstance()

    var window: UIWindow?
    var pedagochiEntryReference: Firebase?
    
//    var session: WCSession? {
//        didSet {
//            if let session = session {
//                
//                //session.delegate = self
//                session.activateSession()
////                if session.paired != true {
////                    print("Apple Watch is not paired")
////                }
////                
////                if session.watchAppInstalled != true {
////                    print("WatchKit app is not installed")
////                }
//            }
//        }
//    }
    override init() {
        super.init()
        //Firebase.defaultConfig().persistenceEnabled = true

        
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
        
      
        
        if FirebaseDataService.dataService.rootReference.authData != nil {
            // user authenticated
            let tabViewController = storyboard.instantiateViewControllerWithIdentifier("tabBarView")
            self.window?.rootViewController = tabViewController
            
        } else {
            
            self.window?.rootViewController = loginViewController
            self.window?.makeKeyAndVisible()
        }
        
        
        //observe user authentication state
        FirebaseDataService.dataService.rootReference.observeAuthEventWithBlock({(authData) in
            if authData != nil{
                self.log.debug("auth data not nil")

                //activate watchkit session
                if PedagochiWatchConnectivity.connectionManager.activate() {
                    PedagochiWatchConnectivity.connectionManager.sendFirebaseUserData()
                    PedagochiWatchConnectivity.connectionManager.startSendingCurrentBGAverage()
                    
                }
                //prompt user for location permission
                let response = LocationManager.sharedInstance.checkCoreLocationPermission()
                if response == true{
                    self.log.debug("starting location updates")
                    LocationManager.sharedInstance.startUpdatingLocation()
                    LocationManager.sharedInstance.regionDelegate = self
                }else{
                    
                }
                
                
                
                NotificationsManager.sharedInstance.buildNotificationSettings()
                //let scheduled = NotificationsManager.sharedInstance.checkIfNotificationsScheduled()
                //if scheduled != true {
                //NotificationsManager.sharedInstance.setNotificationsScheduled()
                // }
                self.handleUnknownNotification() //if launched because of notification, handle it
                
                //NotificationsManager.sharedInstance.setNotificationsUnscheduled()
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                NotificationsManager.sharedInstance.setupDefaultNotificationTimes()
               
//                RulesManager.sharedInstance.buildRules({
//                    success, error in
//                    if success == true{
//                        RulesManager.sharedInstance.evaluateRules()
//                        RulesManager.sharedInstance.drawConclusions()
//                    }
//                })
            }
        })

        // Override point for customization after application launch.
//        if pedagochiEntryReference!.authData != nil {
//            // user authenticated
//            print(pedagochiEntryReference!.authData)
//            let tabViewController = storyboard.instantiateViewControllerWithIdentifier("tabBarView")
//            self.window?.rootViewController = tabViewController
//            
//        } else {
//            
//            //show login view
//           
//            
//            self.window?.rootViewController = loginViewController
//            self.window?.makeKeyAndVisible()
//        }
//        pedagochiEntryReference!.observeAuthEventWithBlock({(authData) in
//            if authData == nil{
////               
//                print("authdata is nil")
////                //show login view
////                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
////                
////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                
////                let loginViewController = storyboard.instantiateViewControllerWithIdentifier("newLoginView")
//                
//                self.window?.rootViewController = loginViewController
//                self.window?.makeKeyAndVisible()
//            }
//        })
        
        
        //setup XCGLogger
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLogLevel: nil)
        
        //setup watch connectivity
        //PedagochiWatchConnectivity.connectionManager.activate()
        //send firebase user data
      //  PedagochiWatchConnectivity.connectionManager.sendFirebaseUserData()
        //start sending updates
      //  PedagochiWatchConnectivity.connectionManager.startSendingCurrentBGAverage()
        
//        if WCSession.isSupported() {
//            log.debug("starting sesion on iphone")
//            session = WCSession.defaultSession()
//        }
        


        
       //LocationManager.sharedInstance.stopMonitoringRegion(Home.sharedInstance.identifier!)
        
 


        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        application.applicationIconBadgeNumber = 0

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       // application.applicationIconBadgeNumber = 0
        //handleUnknownNotification()

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        log.debug("notification delegate called")
      
        handleNotification(notification)

      
        
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        log.debug("new notification delegate called")
        handleNotification(notification)

        completionHandler()
    }
    
    func enteredRegion(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log.debug("region entered!")
    }
    
    func exitedRegion(manager: CLLocationManager, didExitRegion region: CLRegion) {
        log.debug("region exited!")
        let notification = NotificationsManager.sharedInstance.getLocationNotification()
        let isItMorning = TimingManager.sharedInstance.checkIfMorning()
        if isItMorning == true{
            InformationGenerator.sharedInstance.launchLeavingHomeInformationRequest()
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        //UIApplication.sharedApplication().cancelLocalNotification(notification)


    }
    
    func handleNotification(notification: UILocalNotification){
        let infoType = notification.userInfo
        
        if let _ = infoType!["carbs"]{
            InformationGenerator.sharedInstance.launchCarbsInformationrequest()
        }else if let _ = infoType!["exercise"]{
            InformationGenerator.sharedInstance.launchExerciseInformationRequest()
        }
    }
    
    func handleUnknownNotification(){
        if UIApplication.sharedApplication().applicationIconBadgeNumber > 0{
            if TimingManager.sharedInstance.checkHour(1){
                InformationGenerator.sharedInstance.launchCarbsInformationrequest()
                self.log.debug("launched carbs request")

            }else{
                InformationGenerator.sharedInstance.launchExerciseInformationRequest()
                self.log.debug("launched exercise request")

            }
        }
    }


}

//extension AppDelegate: WCSessionDelegate{
//    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
//            var command = message["getCurrentDayBGAverage"] as! Bool
//            log.debug("command received is \(command)")
//            if command == true{
//                print("command received")
//                //calculateCurrentDayBGAverage()
//            }
//            command = message["stopUpdates"] as! Bool
//            if command == true{
//                //removeCurrentDayBGAverageEventObserver()
//            }
//    }
//}

