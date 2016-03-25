//
//  ActivityDetector.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 23/03/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreMotion

class ActivityDetector {
    static let detector = ActivityDetector()
    let activityManager = CMMotionActivityManager()
    
    func startDetection(){
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data: CMMotionActivity?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(data!.stationary == true){
                        print("Stationary")
                    } else if (data!.walking == true){
                        print("walking")

                    } else if (data!.running == true){
                        print("running")

                    } else if (data!.automotive == true){
                        print("automotive")

                    }
                })
                
            })
        }
    }
}