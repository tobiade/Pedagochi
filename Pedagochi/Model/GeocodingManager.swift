//
//  GeocodingManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 30/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import CoreLocation
import XCGLogger
class GeocodingManager {
    let log = XCGLogger.defaultInstance()
    static let sharedInstance = GeocodingManager()
    
    var x: String?
    
    func getCoordinatesForAddress(address: String, completionBlock: (CLLocationCoordinate2D?, NSError?) -> Void){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {
            (placemarks: [CLPlacemark]?, error: NSError?) in
            if error != nil{
                completionBlock(nil, error)
            }else if placemarks?.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                let location = placemark.location
                let coordinates = location?.coordinate
                completionBlock(coordinates,nil)
            }
        })
    }
    
    func testGeoCoder(){
        let addressString = "\(User.sharedInstance.addressLine1) \(x) \(User.sharedInstance.postcode) \(User.sharedInstance.city)"
        getCoordinatesForAddress(addressString, completionBlock: {
            coordinates, error in
            self.log.debug("latitude - \(coordinates?.latitude), longitude - \(coordinates?.longitude)")
        })
    }
    
}