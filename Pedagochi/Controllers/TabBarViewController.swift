//
//  TabBarViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 22/03/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import DynamicButton

class TabBarViewController: UITabBarController {

    var dcPathButton: DCPathButton!
    var dynamicButton: DynamicButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // configureDCPathButton()
        configureDynamicButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureDynamicButton(){
         dynamicButton = DynamicButton(style: .Plus)
        dynamicButton.lineWidth           = 3
        dynamicButton.strokeColor         = UIColor.blackColor()
        dynamicButton.highlightStokeColor = UIColor.grayColor()
        dynamicButton.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height - 25.5)
        //dynamicButton.setStyle(.Close, animated: true)
        dynamicButton.addTarget(self, action: #selector(presentBGEntryScreen), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(dynamicButton)


    }
    
    

    
    func presentBGEntryScreen(sender:UIButton!){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewControllerWithIdentifier("entryNav")
        self.presentViewController(secondVC, animated: true, completion: nil)

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
