//
//  TabBarViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 22/03/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import DynamicButton

class TabBarViewController: UITabBarController, DCPathButtonDelegate {

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
        dynamicButton.addTarget(self, action: "presentBGEntryScreen:", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(dynamicButton)


    }
    
    func configureDCPathButton() {
        
        dcPathButton = DCPathButton(centerImage: UIImage(named: "chooser-button-tab"), highlightedImage: UIImage(named: "chooser-button-tab-highlighted"))
        
        dcPathButton.delegate = self
        dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.width/2, self.view.bounds.height - 25.5)
        dcPathButton.allowSounds = true
        dcPathButton.allowCenterButtonRotation = true
        dcPathButton.bloomRadius = 105
        
        var itemButton_1 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-music"), highlightedImage: UIImage(named: "chooser-moment-icon-music-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        var itemButton_2 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-place"), highlightedImage: UIImage(named: "chooser-moment-icon-place-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        var itemButton_3 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-camera"), highlightedImage: UIImage(named: "chooser-moment-icon-camera-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        var itemButton_4 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-thought"), highlightedImage: UIImage(named: "chooser-moment-icon-thought-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        var itemButton_5 = DCPathItemButton(image: UIImage(named: "chooser-moment-icon-sleep"), highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        
        
        dcPathButton.addPathItems([itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5])
        
        self.view.addSubview(dcPathButton)
        
    }
    
    // DCPathButton Delegate
    //
    func pathButton(dcPathButton: DCPathButton!, clickItemButtonAtIndex itemButtonIndex: UInt) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewControllerWithIdentifier("bgEntry")//        var alertView = UIAlertView(title: "", message: "You tap at index \(itemButtonIndex)", delegate: nil, cancelButtonTitle: "Ok")
//        
//        alertView.show()
        print(itemButtonIndex)
        
        if itemButtonIndex == 0 {
            self.presentViewController(secondVC, animated: true, completion: nil)
        }
        
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
