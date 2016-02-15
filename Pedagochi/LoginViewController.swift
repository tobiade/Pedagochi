//
//  LoginViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 12/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    let login = "LoginToHome"
    let pedagochiEntryReference = Firebase(url: "https://brilliant-torch-960.firebaseio.com/pedagochi-entries")


    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        pedagochiEntryReference.observeAuthEventWithBlock({(authData) in
//            if authData != nil{
//                print(authData.description)
//                self.performSegueWithIdentifier(self.login, sender: nil)
//            }else{
//                print("authdata is nil")
//            }
//        })

    }
    
    
    @IBAction func loginDidTouch(sender: AnyObject) {
        pedagochiEntryReference.authUser(textFieldEmail.text, password: textFieldPassword.text, withCompletionBlock: {(error, auth) in
            self.performSegueWithIdentifier(self.login, sender: nil)
        })    }

    @IBAction func signUpButtonTouched(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
            message: "Register",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let emailField = alert.textFields![0]
                let passwordField = alert.textFields![1]
                self.pedagochiEntryReference.createUser(emailField.text, password: passwordField.text, withCompletionBlock: {error in
                    if error == nil{
                        self.pedagochiEntryReference.authUser(emailField.text, password: passwordField.text, withCompletionBlock: {(error,auth) -> Void in
                            
                            
                        })
                    }
                    
                })
                
                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
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

}
