//
//  NetworkingManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 28/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import Alamofire
import XCGLogger
class NetworkingManager {
    let log = XCGLogger.defaultInstance()
    static let sharedInstance = NetworkingManager()
    let url = "http://young-beyond-86705.herokuapp.com/api/generateRecommendation"
    
    func postJSON(data: [String:AnyObject]){
        Alamofire.request(.POST, url, parameters: data, encoding: .JSON).responseJSON(completionHandler: {
            response in
            //self.log.debug("result is \(response.result.value)")
        })
            
        }
}
