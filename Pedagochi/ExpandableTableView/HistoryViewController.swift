//
//  HistoryViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 18/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import CoreMotion
class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    let activityManager = CMMotionActivityManager()
    var activityEntries = [String]()

    //@IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var tableView: UITableView!
    
    var items:[[Int]?] = []

    //MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create data
//        for var i = 0; i < Int(arc4random_uniform(100)); i++ {
//            items.append([])
//            for var j = 0; j < Int(arc4random_uniform(100)); j++ {
//                items[i]!.append(j)
//            }
//        }
        
        startDetection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
   
    
    // MARK: UITableViewDataSource
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 80
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if (!items.isEmpty) {
//            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
//                return items[section]!.count
//            }
//        }
        return activityEntries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = activityEntries[indexPath.row]
        //cell.textLabel?.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // MARK: UITableViewDelegate
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var headerView = HeaderView(tableView: self.tableView, section: section)
//        headerView.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(100)) / 100.0,
//            green: CGFloat(arc4random_uniform(100)) / 100.0,
//            blue: CGFloat(arc4random_uniform(255)) / 100.0,
//            alpha: 1)
//        
//        var label = UILabel(frame: headerView.frame)
//        label.text = "Section \(section), touch here!"
//        label.textAlignment = NSTextAlignment.Center
//        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
//        label.textColor = UIColor.whiteColor()
//        
//        headerView.addSubview(label)
//        
//        
//        return headerView
//    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
    
    func startDetection(){
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data: CMMotionActivity?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(data!.stationary == true){
                        print("Stationary")
                        self.activityEntries.append("stationary")
                    } else if (data!.walking == true){
                        print("walking")
                        self.activityEntries.append("walking")

                    } else if (data!.running == true){
                        print("running")
                        self.activityEntries.append("running")

                    } else if (data!.automotive == true){
                        print("automotive")
                        self.activityEntries.append("automotive")

                    }
                
                self.tableView.reloadData()
                })
                
            })
        }else{
            let alertController = UIAlertController(title: "Error", message:
                "M7 chip not available", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
