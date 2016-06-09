//
//  SettingsTableViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 12/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import XCGLogger
class SettingsTableViewController: UITableViewController {
    //logger
    let log = XCGLogger.defaultInstance()
    
    var sessionActivated = false

  //  @IBOutlet weak var pairAppleWatchSwitch: UISwitch!
    @IBOutlet weak var postGlucoseAverageUpdatesSwitch: UISwitch!
    
    @IBOutlet weak var postBGUpdateToNewsFeedSwitch: UISwitch!
    
   // @IBOutlet weak var healthKitDataSwitch: UISwitch!
    
    
//    required init(coder aDecoder: NSCoder){
//        log.debug("settings page init called")
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let glucoseUpdateSwitchPosition = defaults.objectForKey("glucoseUpdateSwitch") as? Bool
//        if let position = glucoseUpdateSwitchPosition where position == true{
//            postGlucoseAverageUpdatesSwitch.on = true
//            PedagochiWatchConnectivity.connectionManager.startSendingCurrentBGAverage()
//        }
//        if let position = glucoseUpdateSwitchPosition where position == false{
//            postGlucoseAverageUpdatesSwitch.on = false
//        }
//        
//        super.init(coder: aDecoder)!
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
        
       // self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg12"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //disable apple watch options
        //postGlucoseAverageUpdatesSwitch.enabled = false

        
        //add target for apple watch switch
//        pairAppleWatchSwitch.addTarget(self, action: #selector(pairAppleWatchSwitchChanged), forControlEvents: .ValueChanged)
//        postGlucoseAverageUpdatesSwitch.addTarget(self, action: #selector(postGlucoseAverageUpdatesSwitchChanged), forControlEvents: .ValueChanged)
        postBGUpdateToNewsFeedSwitch.addTarget(self, action: #selector(updatesSwitchChanged), forControlEvents: .ValueChanged)
         //healthKitDataSwitch.addTarget(self, action: #selector(healthKitSwitchChanged), forControlEvents: .ValueChanged)
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let glucoseUpdateSwitchPosition = defaults.objectForKey("glucoseUpdateSwitch") as? Bool
//        if let position = glucoseUpdateSwitchPosition where position == true{
//            postGlucoseAverageUpdatesSwitch.on = true
//        }
//        if let position = glucoseUpdateSwitchPosition where position == false{
//            postGlucoseAverageUpdatesSwitch.on = false
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func healthKitSwitchChanged(mySwitch: UISwitch){
        if mySwitch.on{
            
        }else{
            
        }
    }
    

    func postGlucoseAverageUpdatesSwitchChanged(mySwitch: UISwitch){
        let defaults = NSUserDefaults.standardUserDefaults()
        if mySwitch.on{
            do{
                try PedagochiWatchConnectivity.connectionManager.checkSessionCompatibility()
                PedagochiWatchConnectivity.connectionManager.sendFirebaseUserData()
                PedagochiWatchConnectivity.connectionManager.startSendingCurrentBGAverage()
                defaults.setBool(true, forKey: "glucoseUpdateSwitch")
            }
            catch WatchError.WatchNotPaired{
                showAlertController("Watch not paired")
                postGlucoseAverageUpdatesSwitch.on = false
            }
            catch WatchError.WatchAppNotInstalled{
                showAlertController("Watch app not installed")
                postGlucoseAverageUpdatesSwitch.on = false
            }
            catch WatchError.WatchConnectivityNotSupported{
                showAlertController("Watch connectivity not supported")
                postGlucoseAverageUpdatesSwitch.on = false

            }
            catch {
                showAlertController("Unknown error")
            }

            
        }else{
            log.debug("bg updates stopped")
            PedagochiWatchConnectivity.connectionManager.removeCurrentDayBGAverageEventObserver()
            defaults.setBool(false, forKey: "glucoseUpdateSwitch")

        }
    }
    
    func updatesSwitchChanged(mySwitch:UISwitch){
        if mySwitch.on{
            SettingsManager.sharedInstance.postBloodGlucoseUpdatesToNewsFeed = true
        }else{
            SettingsManager.sharedInstance.postBloodGlucoseUpdatesToNewsFeed = false

        }
    }
    
    private func showAlertController(message: String){
        let alertController = UIAlertController(title: "Pedagochi", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
