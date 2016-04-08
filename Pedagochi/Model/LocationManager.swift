//
//  LocationManager.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 08/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreLocation

//class LocationManagerDelegate
class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    //var delegate: UIViewController?
    
    override init(){
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkCoreLocationPermission() -> Bool{
        let authorizationStatus = CLLocationManager.authorizationStatus()
        var response: Bool!
        if authorizationStatus == .AuthorizedAlways{
            //locationManager.startUpdatingLocation()
            response = true
        }else if authorizationStatus == .NotDetermined{
            locationManager.requestAlwaysAuthorization()
            //if user authorizes, start updating location
            if CLLocationManager.authorizationStatus() == .AuthorizedAlways{
                //locationManager.startUpdatingLocation()
                response = true
            }else{
                response = false
            }
        }
        else if authorizationStatus == .Restricted{
//            let alertController = UIAlertController(title: "Error", message:
//                "Pedagochi not authorised to use location", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
            //print("Pedagochi not authorised to use location")
            response = false
        }
        return response
    }
    
    func startUpdatingLocation(){
        locationManager.startUpdatingLocation()
    }
    
    //MARK: LocationManager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        //print(currentLocation.coordinate.latitude)
        
        //locationManager.stopUpdatingLocation()
    }
    
}
