//
//  Home.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 30/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreLocation
class Home {
    static let sharedInstance = Home()
    var coordinate: CLLocationCoordinate2D?
    var radius: CLLocationDistance?
    var identifier: String? = "home"
    var notifyOnExit = true
    var notifyOnEntry = false
    
}
