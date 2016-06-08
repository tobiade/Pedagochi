////
////  CareCardViewController.swift
////  Pedagochi
////
////  Created by Lanre Durosinmi-Etti on 02/05/2016.
////  Copyright © 2016 Tobi Adewuyi. All rights reserved.
////
//
//import UIKit
//import CareKit
//import ResearchKit
//
//class CareCardViewController: UIViewController {
//    private let storeManager = CarePlanStoreManager.sharedCarePlanStoreManager
//    
//    private var sampleData: SampleData?
//    
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        sampleData = SampleData(carePlanStore: storeManager.store)
//        //var viewcontrollers = [UIViewController]()
//        let careCardViewController = careCardVC()
//        //careCardViewController.title = "Pedagochi"
////        careCardViewController.view.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.view.frame.width)!, height: (self.navigationController?.view.frame.height)! - 50)
//        //viewcontrollers.append(careCardViewController)
//        //self.navigationController?.setViewControllers(viewcontrollers, animated: true)//(careCardVC(), animated: true)
//        //self.presentViewController(careCardViewController, animated: true, completion: nil)
//
//        view.addSubview(careCardViewController.view)
//     
//        self.addChildViewController(careCardViewController)
//
//        
//        //presentVC(careCardViewController)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
// 
//    
//    private func completeEvent(event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
//        store.updateEvent(event, withResult: result, state: .Completed) { success, _, error in
//            if !success {
//                print(error?.localizedDescription)
//            }
//        }
//    }
//    
//    
//    func careCardVC() -> OCKCareCardViewController{
//        let viewController = OCKCareCardViewController(carePlanStore: storeManager.store)
//        
//        // Setup the controller's title and tab bar item
//        viewController.title = NSLocalizedString("Care Card", comment: "")
//        //        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
//        
//        return viewController
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
