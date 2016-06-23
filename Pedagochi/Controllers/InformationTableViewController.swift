//
//  InformationTableViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 31/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import XCGLogger
class InformationTableViewController: UITableViewController {
    let log = XCGLogger.defaultInstance()
    var loadInitialData = true
    var informationArray = [InfoModel]()
    var widthBounds: CGFloat?
    var heightBounds: CGFloat?
    let segueIdentifier = "showMoreInfoSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 32.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 32.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1)]
        self.navigationController?.navigationBar.translucent = false
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg12"))
        
        
        widthBounds = UIScreen.mainScreen().bounds.width
        heightBounds = UIScreen.mainScreen().bounds.height
        
        showInformationInitial()
        //showInformationUpdates()
        //InformationGenerator.sharedInstance.launchCarbsInformationrequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return informationArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! InformationTableViewCell
        let info = informationArray[indexPath.row]
        cell.infoLabel.text = info.information
        cell.urlLabel.text = info.url
        
        cell.urlLabel.handleURLTap({
            url in
            self.log.debug("url tapped is \(url)")
            self.loadWebView(url)
        })
        
        return cell

    }
    func loadWebView(url: NSURL){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewControllerWithIdentifier("webViewNav") as! UINavigationController
        let vc = navVC.viewControllers.first as! WebViewController
        

        
        vc.url = url
        
        //webview.delegate = self
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let info = informationArray[indexPath.row]
        
    }
    func showInformationInitial(){
        let reference = FirebaseDataService.dataService.infoReference
        reference.observeEventType(.Value, withBlock: {
            snapshot in
            if self.loadInitialData == true{
                if let informationSet = snapshot.children.allObjects as? [FDataSnapshot]{
                    for information in informationSet{
                        let infoTitBit  = InfoModel(dict: information.value)
                        self.informationArray.insert(infoTitBit, atIndex: 0)
                        self.log.debug(infoTitBit.information)
                    }
                }
                //self.loadInitialData = false
                self.tableView.reloadData()
                self.log.debug("initial data loaded")
            }
        })
    }
    
    func showInformationUpdates(){
        let reference = FirebaseDataService.dataService.infoReference
        reference.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            self.log.debug("entered child added for info updates")
            if self.loadInitialData == false {
                let infoTitBit  = InfoModel(dict: snapshot.value)
                self.informationArray.insert(infoTitBit, atIndex: 0)
                
                self.tableView.reloadData()
            }
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier{
            if let infoCellVC = segue.destinationViewController as? InfoCellViewController{
                if let cellIndex = tableView.indexPathForSelectedRow{
                    let info = informationArray[cellIndex.row]
                    log.debug("in segue")
                   infoCellVC.info = info
                }
            }
           
        }
    }
    

    @IBAction func exerciseButtonDidTouch(sender: AnyObject) {
        InformationGenerator.sharedInstance.launchExerciseInformationRequest()
    }

    @IBAction func carbsButtonDidTouch(sender: AnyObject) {
        InformationGenerator.sharedInstance.launchCarbsInformationrequest()
    }
    

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
