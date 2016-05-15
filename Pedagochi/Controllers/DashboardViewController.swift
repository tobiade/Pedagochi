//
//  DashboardViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 03/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import CareKit
import ResearchKit
import XCGLogger
class DashboardViewController: UIViewController {
    private let storeManager = CarePlanStoreManager.sharedCarePlanStoreManager
    
    private var sampleData: SampleData?
    
    let log = XCGLogger.defaultInstance()
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    
    private func showAlertController(message: String){
        let alertController = UIAlertController(title: "Pedagochi", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sampleData = SampleData(carePlanStore: storeManager.store)

        // Do any additional setup after loading the view.
        let careCardViewController = careCardVC()
        //careCardViewController.title = "Pedagochi"
        //        careCardViewController.view.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.view.frame.width)!, height: (self.navigationController?.view.frame.height)! - 50)
        //viewcontrollers.append(careCardViewController)
        //self.navigationController?.setViewControllers(viewcontrollers, animated: true)//(careCardVC(), animated: true)
        //self.presentViewController(careCardViewController, animated: true, completion: nil)
        
       // careCardViewController.view.frame = CGRect(x: 0, y: 129, width: 375, height: 489)
        careCardViewController.view.frame = holderView.bounds
        holderView.addSubview(careCardViewController.view)
        
        self.addChildViewController(careCardViewController)
        
        careCardViewController.parentViewController?.navigationItem.rightBarButtonItem = careCardViewController.navigationItem.rightBarButtonItem
        
        //notify when app enters foreground
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(outputStepCount), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func outputStepCount(){
        HealthManager.sharedInstance.getStepCount() {
            result, error in
            if let numberOfSteps = result{
                //let numberOfSteps = Int(quantity.doubleValueForUnit(HealthManager.sharedInstance.stepsUnit))
                self.log.debug("step count is \(numberOfSteps)")
            }
        }
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //authorize healthkit
//        HealthManager.sharedInstance.authorizeHealthKit({
//            success, error in
//            if success{
//                self.log.debug("healthkit authorised")
//                self.outputStepCount()
//            }else{
//                self.log.debug("failed to authorise healthkit")
//            }
//        })
//
//    }
    
    func careCardVC() -> OCKCareCardViewController{
        let viewController = OCKCareCardViewController(carePlanStore: storeManager.store)
        
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Care Card", comment: "")
        //        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
        
        return viewController
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
