//
//  HistoryViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 18/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    //@IBOutlet weak var tableView:UIExpandableTableView!
    @IBOutlet weak var tableView: UIExpandableTableView!
    
    var items:[[Int]?] = []

    //MARK: view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create data
        for var i = 0; i < Int(arc4random_uniform(100)); i++ {
            items.append([])
            for var j = 0; j < Int(arc4random_uniform(100)); j++ {
                items[i]!.append(j)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
   
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (!items.isEmpty) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                return items[section]!.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = "section \(indexPath.section) row \(indexPath.row)"
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = HeaderView(tableView: self.tableView, section: section)
        headerView.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(100)) / 100.0,
            green: CGFloat(arc4random_uniform(100)) / 100.0,
            blue: CGFloat(arc4random_uniform(255)) / 100.0,
            alpha: 1)
        
        var label = UILabel(frame: headerView.frame)
        label.text = "Section \(section), touch here!"
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = UIColor.whiteColor()
        
        headerView.addSubview(label)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
