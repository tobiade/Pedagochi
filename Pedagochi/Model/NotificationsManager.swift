//
//  NotificationsManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 29/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import XCGLogger
import CoreLocation
class NotificationsManager {
    let log = XCGLogger.defaultInstance()
    static let sharedInstance = NotificationsManager()
    
    func buildNotificationSettings(){
        let notificationSettings: UIUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()!
        
        if notificationSettings.types == UIUserNotificationType.None {
            let notificationTypes: UIUserNotificationType = [.Alert, .Badge]
            
            let viewAction = UIMutableUserNotificationAction()
            viewAction.identifier = "viewAction"
            viewAction.title = "View"
            viewAction.activationMode = UIUserNotificationActivationMode.Foreground
            viewAction.destructive = false
            viewAction.authenticationRequired = false
            
            let actionsArrayMinimal = NSArray(object: viewAction)
            
            let pedagochiInfoNotifierCategory = UIMutableUserNotificationCategory()
            pedagochiInfoNotifierCategory.identifier = "pedagochiInfoNotifierCategory"
            pedagochiInfoNotifierCategory.setActions(actionsArrayMinimal as! [UIUserNotificationAction] , forContext: .Minimal)
            
            let categoriesForSettings = NSSet(object: pedagochiInfoNotifierCategory)
            
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as! Set<UIUserNotificationCategory>)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
            
        }
     
        
        
    }
    private func scheduleCustomNotification(notification: UILocalNotification, hour:Int, minute: Int, second: Int){
//        let notification = UILocalNotification()
//        notification.alertBody = "Information available!"
//        notification.alertAction = "Open"
//        notification.fireDate = scheduleNotificationAtHour(hour,minute: minute,second: second)
//        notification.repeatInterval = .Day
//        notification.category = "pedagochiInfoNotifierCategory"
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        log.debug("Notification scheduled")
        
    }
    
    
    private func addNotification(hour: Int, minute: Int, second: Int, notifierType: String){
        let notification = UILocalNotification()
        notification.alertBody = "Information available!"
        notification.alertAction = "Open"
        notification.fireDate = scheduleNotificationAtHour(hour,minute: minute,second: second)
        notification.repeatInterval = .Day
        notification.userInfo = ["notificationType": notifierType]
        notification.category = "pedagochiInfoNotifierCategory"
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        log.debug("Notification scheduled")
        
    }
     func getLocationNotification() -> UILocalNotification {
        let notification = UILocalNotification()
        notification.alertBody = "Have a piece of juicy information before you step out!"
        notification.alertAction = "Open"
        notification.userInfo = ["notificationType": "leavingHome"]
        //notification.fireDate = scheduleNotificationAtHour(hour,minute: minute,second: second)
        //notification.repeatInterval = .Day
        //notification.regionTriggersOnce = false
        //notification.region = region
        notification.category = "pedagochiInfoNotifierCategory"
        //notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        log.debug("Region Notification scheduled")
        return notification
        
    }
    
    private func scheduleNotificationAtHour(hour: Int, minute: Int, second: Int) -> NSDate{
        let dateComponents: NSDateComponents = NSCalendar.currentCalendar().components([.Day,.Month,.Year], fromDate: NSDate())
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        let fixedDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        return fixedDate!
        
    }
    
    func setupDefaultNotificationTimes() {
        //addNotification(, minute: 15,second: 0) //10am
        addNotification(13, minute: 0, second: 0, notifierType: "carbs") //1pm
        addNotification(20, minute: 0, second: 0,notifierType: "exercise") //8pm
        
//        addNotification(0, minute: 15,second: 0) //10am
//        addNotification(0, minute: 16, second: 0) //2pm
//        addNotification(0, minute: 17, second: 0) //8pm
    }
//    func setupLocationNotifications(){
//        addRegionNotification()
//    }
    
    func checkIfNotificationsScheduled() -> Bool{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let value = userDefaults.objectForKey("notifications") as? Bool
        guard value != nil || value == false else{
            return false
        }
        return true
    }
    func setNotificationsScheduled(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: "notifications")
    }
    func setNotificationsUnscheduled(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(false, forKey: "notifications")
    }
}
