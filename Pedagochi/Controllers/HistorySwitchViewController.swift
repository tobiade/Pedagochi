//
//  HistorySwitchViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 29/03/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import DGRunkeeperSwitch
class HistorySwitchViewController: UIViewController {

    @IBOutlet weak var pedagochiEntryContainerView: UIView!
    @IBOutlet weak var activityEntryContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSwitch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupSwitch(){
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        navigationController!.navigationBar.translucent = false
        navigationController!.navigationBar.barTintColor = UIColor(red: 252.0/255.0, green: 182.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        
        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Feed", rightTitle: "Leaderboard")
        runkeeperSwitch.backgroundColor = UIColor(red: 229.0/255.0, green: 163.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor(red: 255.0/255.0, green: 196.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        runkeeperSwitch.addTarget(self, action: #selector(HistorySwitchViewController.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
        navigationItem.titleView = runkeeperSwitch
    }
    
    func switchValueDidChange(sender: DGRunkeeperSwitch!) {
        //print("valueChanged: \(sender.selectedIndex)")
//        switch sender.selectedIndex{
//        case 0:
//            UIView.animateWithDuration(0.2, animations: {
//                self.pedagochiEntryContainerView.alpha = 1
//                self.activityEntryContainerView.alpha = 0
//            })
//        case 1:
//            UIView.animateWithDuration(0.2, animations: {
//                self.pedagochiEntryContainerView.alpha = 0
//                self.activityEntryContainerView.alpha = 1
//            })
//        default: break
//            
//        }
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
