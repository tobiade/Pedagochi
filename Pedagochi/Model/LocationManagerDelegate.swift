//
//  LocationManagerDelegate.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 08/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreLocation
protocol LocationManagerDelegate {
    func didUpdateLocation(locations: [CLLocation])
}

protocol RegionEventDelegate {
    func enteredRegion(manager: CLLocationManager, didEnterRegion region: CLRegion)
    func exitedRegion(manager: CLLocationManager, didExitRegion region: CLRegion)

}
