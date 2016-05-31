//
//  InformationGenerator.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 31/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class InformationGenerator {
    static let sharedInstance = InformationGenerator()
    
    func launchCarbsInformationrequest(){
        ContextBuilder.sharedInstance.genericCarbsRelatedContext({
            result, error in
            if error == nil{
                NetworkingManager.sharedInstance.postJSON(result!)
            }
        
        })
    }
}