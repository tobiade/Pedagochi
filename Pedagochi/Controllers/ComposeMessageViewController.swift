//
//  ComposeMessageViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 17/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit

class ComposeMessageViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var charactersLeftLabel: UILabel!
    @IBOutlet weak var newMessageTextView: UITextView!
    let textViewPlaceholder = "Hey! What's happening?"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        //self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg12"))
        setuptextView()
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func viewDidLayoutSubviews() {
//        newMessageTextView.setContentOffset(CGPointZero, animated: false)
//    }
    func setuptextView(){
        newMessageTextView.text = textViewPlaceholder
        newMessageTextView.textColor = UIColor.whiteColor()
       // newMessageTextView.tintColor = UIColor(red: 255/255.0, green: 0, blue: 128/255.0, alpha: 1)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if newMessageTextView.textColor == UIColor.lightGrayColor(){
            newMessageTextView.text = nil
            newMessageTextView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if newMessageTextView.text.isEmpty{
            newMessageTextView.text = textViewPlaceholder
            newMessageTextView.textColor = UIColor.blackColor()
        }
    }
    

    @IBAction func sendMessage(sender: AnyObject) {
        let message = newMessageTextView.text
        if message != "" {
            let newMessage: [String:AnyObject?] = [ "message": message,
                               "postedBy": User.sharedInstance.firstName,
                               "postedAt": NSDate().timeIntervalSince1970,
                               "messageType": MessageType.PersonlMessage.rawValue,
                               "uid": FirebaseDataService.dataService.userId]
            
            FirebaseDataService.dataService.postNewMessage(newMessage as! [String:AnyObject])
        }
        
        if let navController = self.navigationController{
            navController.popViewControllerAnimated(true)
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingChar: Int = 140 - newLength
        
        charactersLeftLabel.text = "\(remainingChar)"
        
        return (newLength > 140) ? false : true
        
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

