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
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //logger
    let log = XCGLogger.defaultInstance()

    var window: UIWindow?
    var pedagochiEntryReference: Firebase?
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
            if authData == nil{
                
                //print("authdata is nil")
                //show login view
                //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
               // let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                //let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
                //
                self.log.debug("unauth called")

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
                
                self.window?.rootViewController = loginViewController
                self.window?.makeKeyAndVisible()
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

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

