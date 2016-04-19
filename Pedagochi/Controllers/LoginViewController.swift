//
//  LoginViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 12/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
import TKSubmitTransition
import XCGLogger
class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let log = XCGLogger.defaultInstance()
    
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginDidTouch(button: TKTransitionSubmitButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewControllerWithIdentifier("tabBarView")
        tabBarVC.transitioningDelegate = self
        button.animate(1, completion: { () -> () in
        })
        //        self.pedagochiEntryReference.authUser(self.textFieldEmail.text, password: self.textFieldPassword.text, withCompletionBlock: {(error, auth) in
        //            if auth != nil{
        //                //self.performSegueWithIdentifier(self.login, sender: nil)
        //
        //                self.presentViewController(tabBarVC, animated: true, completion: nil)
        //                 //button.layer.removeAllAnimations()
        //
        //
        //            }else{
        //                print(error.description)
        //            }
        //        })
        //
        FirebaseDataService.dataService.rootReference.authUser(textFieldEmail.text,
                                                               password: textFieldPassword.text, withCompletionBlock:
            {(error, auth) in
                if auth != nil{
                    self.log.debug("")
                    self.presentViewController(tabBarVC, animated: true, completion: nil)
                    //send firebase user data
                     //PedagochiWatchConnectivity.connectionManager.sendFirebaseUserData()
                    //start sending updates
                    // PedagochiWatchConnectivity.connectionManager.startSendingCurrentBGAverage()
                   
                }else{
                    print(error.description)
                }
        })
        
        
        
    }
    
    @IBAction func signUpButtonTouched(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        let nameField = alert.textFields![0]
                                        let emailField = alert.textFields![1]
                                        let passwordField = alert.textFields![2]
                                        
                                        FirebaseDataService.dataService.rootReference.createUser(emailField.text,
                                                                                                 password: passwordField.text, withValueCompletionBlock:
                                            {error, result in
                                                if error == nil{
                                                    //save unique user id
//                                                    let uid = result["uid"] as? String
//                                                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                                                    User.sharedInstance.firstName = nameField.text!
                                                    User.sharedInstance.emailAddress = emailField.text!
//                                                    
//                                                    
                                                    let newUser = ["emailaddress": emailField.text!,
                                                        "name": nameField.text!
                                                    ]
                                                    
                                                    FirebaseDataService.dataService.createNewUserAccount(newUser, userId: result["uid"] as! String)
                                                    
                                                    
                                                    /*set email and password in login view so we don't have
                                                     to enter them twice*/
                                                    self.textFieldEmail.text = emailField.text
                                                    self.textFieldPassword.text = passwordField.text
                                                }else{
                                                    //what went wrong?
                                                    //print(error.description)
                                                    self.log.debug(error.description)
                                                }
                                                
                                        })
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textName) -> Void in
            textName.placeholder = "Enter your name"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
        //        let fadeInAnimator = TKFadeInAnimator()
        //        return fadeInAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
