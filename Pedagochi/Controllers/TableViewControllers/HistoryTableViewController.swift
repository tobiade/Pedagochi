//
//  HistoryTableTableViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 29/03/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import XCGLogger
class HistoryTableViewController: UITableViewController {
    let log = XCGLogger.defaultInstance()
    var pedagochiEntryDictionary = [String:[PedagochiEntry]]()
    var sectionTitles = [String]()
    let cellSegueIdentifier = "showHistoryDetailsSegue"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        fetchHistory()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == cellSegueIdentifier{
           let historyCellViewController = segue.destinationViewController as? HistoryCellViewController
            if let cellIndex = tableView.indexPathForSelectedRow{
                let entryKey = sectionTitles[cellIndex.section]
                let pedagochiEntryArray = pedagochiEntryDictionary[entryKey]
                let pedagochiEntry = pedagochiEntryArray![cellIndex.row]
                historyCellViewController?.pedagochiEntry = pedagochiEntry
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchHistory(){
        let entryRef = FirebaseDataService.dataService.currentUserPedagochiEntryReference
        
        entryRef.queryOrderedByKey().observeEventType(.Value, withBlock: {snapshot in
            
            for parentNode in snapshot.children.allObjects as! [FDataSnapshot]{
                var entriesArray: [PedagochiEntry] = []
                for entry in parentNode.children.allObjects as! [FDataSnapshot]{
                    //                var dict = [String:AnyObject]()
                    //                dict[snapshot.key] = entry.value
                    let pedagochiEntry = PedagochiEntry(dict: entry.value)
                    //self.log.debug("\(pedagochiEntry.bloodGlucoseLevel)")
                    entriesArray.append(pedagochiEntry)
                }
                if self.sectionTitles.contains(parentNode.key) == false{
                    self.sectionTitles.append(parentNode.key)
                }
                self.sortEntryTimesLatestFirst(&entriesArray)
                self.pedagochiEntryDictionary[parentNode.key] = entriesArray
                
            }
            self.sortArrayLargestFirst(&self.sectionTitles)
            //self.log.debug(self.pedagochiEntryDictionary.description)
            self.tableView.reloadData()
        })
        
    }
    
    func sortEntryTimesLatestFirst(inout array: [PedagochiEntry]){
        array.sortInPlace({
            $0.time > $1.time
        })
    }
    func sortArrayLargestFirst(inout array: [String]){
        array.sortInPlace({
            $0 > $1
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }
    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sectionTitles[section]
        let entryArray = pedagochiEntryDictionary[sectionName]
        return entryArray!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryTableViewCell
        let sectionName = sectionTitles[indexPath.section]
        let entryArray = pedagochiEntryDictionary[sectionName]
        let bgLevel = entryArray![indexPath.row].bloodGlucoseLevel
        let carbs = entryArray![indexPath.row].carbs
        let time = entryArray![indexPath.row].time
        
        if let unwrappedbgLevel = bgLevel{
            cell.bloodGlucoseLabel.text = String(unwrappedbgLevel)
        }else{
            cell.bloodGlucoseLabel.text = "-"
        }
        if let unwrappedCarbs = carbs{
            cell.carbsLabel.text = String(unwrappedCarbs)
        }else{
            cell.carbsLabel.text = "-"
            cell.carbsLabel.textAlignment = .Center
            cell.carbsLabel.sizeToFit() //doesn'tlook like this does anything
        }
        if let unwrappedTime = time{
            cell.timeLabel.text = String(unwrappedTime)
        }else{
            cell.timeLabel.text = "-"
            cell.timeLabel.sizeToFit() //doesn'tlook like this does anything
        }


        
        return cell
    }
    
    
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
