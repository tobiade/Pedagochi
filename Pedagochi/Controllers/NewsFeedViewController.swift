//
//  NewsFeedViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 14/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import AFDateHelper
import XCGLogger
class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let logger = XCGLogger.defaultInstance()
    var newsFeedMessages = [NewsFeedMessage]()
    let newsFeedReference = FirebaseDataService.dataService.newsFeedReference
    var loadInitialData = true
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchInitialData() //setup single event listener to grab all messages
        fetchDataUpdates() //setup event listener to fetch only new messages
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchInitialData(){
        newsFeedReference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if self.loadInitialData == true{
                if let messages = snapshot.children.allObjects as? [FDataSnapshot]{
                    for message in messages{
                        let newMessage = NewsFeedMessage(dict: message.value)
                        self.newsFeedMessages.insert(newMessage, atIndex: 0)
                    }
                }
                self.loadInitialData = false
                self.tableView.reloadData()
            }
        })
        
    }
    func fetchDataUpdates(){
        newsFeedReference.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            if self.loadInitialData == false{
                let newMessage = NewsFeedMessage(dict: snapshot.value)
                self.newsFeedMessages.insert(newMessage, atIndex: 0)
                self.tableView.reloadData()
            }
        })
        
        
    }
    //    func prependMessagesToArrayForTableView(snapshot: FDataSnapshot){
    //        if let messages = snapshot.children.allObjects as? [FDataSnapshot]{
    //            for message in messages{
    //                let newMessage = NewsFeedMessage(dict: message.value)
    //                self.newsFeedMessages.insert(newMessage, atIndex: 0)
    //            }
    //        }
    //
    //    }
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        return 1
    //    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeedMessages.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = newsFeedMessages[indexPath.row]
        let messageType = message.messageType
        var cell = UITableViewCell()

        
        
        let dateAndTime = NSDate(timeIntervalSince1970: message.postedAt!)

        switch messageType! {
        case MessageType.PersonlMessage.rawValue:
            let customcell = tableView.dequeueReusableCellWithIdentifier("newsFeedMessageCell") as! NewMessageTableViewCell
            // let message = newsFeedMessages[indexPath.row]
            customcell.messageTextView.text = message.message
            customcell.nameLabel.text = message.postedBy
            customcell.timePostedLabel.text = dateAndTime.relativeTimeToString()
            cell = customcell
 
        case MessageType.BloodGlucoseUpdate.rawValue:
            let customcell = tableView.dequeueReusableCellWithIdentifier("newsFeedBGUpdateCell") as! NewBloodGlucoseUpdateTableViewCell
            // let message = newsFeedMessages[indexPath.row]
            customcell.bloodGlucoseLabel.text = message.message
            customcell.nameLabel.text = message.postedBy
            customcell.timePostedLabel.text = dateAndTime.relativeTimeToString()
            cell = customcell
            
        default:
            break
        }
        
       
        
        return cell
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
