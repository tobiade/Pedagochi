//
//  SettingsManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 18/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class SettingsManager {
    static let sharedInstance = SettingsManager()
    
    var postBloodGlucoseUpdatesToNewsFeed: Bool = false
}