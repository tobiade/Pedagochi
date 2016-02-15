//
//  HomeViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 15/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    let pedagochiEntryReference = Firebase(url: "https://brilliant-torch-960.firebaseio.com/pedagochi-entries")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButton(sender: AnyObject) {
        pedagochiEntryReference.unauth()
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
