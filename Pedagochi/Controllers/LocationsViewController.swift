//
//  LocationsViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 30/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import XCGLogger
class LocationsViewController: UIViewController, LocationManagerDelegate {
    let log = XCGLogger.defaultInstance()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var resultSearchController: UISearchController?
    
    var imageToggle = false
    
    var selectedPin: MKPlacemark?
    
    var homeAnnotation = MKPointAnnotation()


    @IBOutlet weak var locationsView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.delegate = self
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as? LocationSearchTableTableViewController
        locationSearchTable?.mapView = locationsView
        locationSearchTable!.mapSearchHandlerDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for your home"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        log.debug("map view viewdidload")
        
//        if let homeAnnotation = userDefaults.objectForKey("home"){
//            locationsView.addAnnotation(homeAnnotation as! MKAnnotation)
//        }
        FirebaseDataService.dataService.homeReference.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if snapshot.value is NSNull {
              return
            }else{
                let result = snapshot.value
                let latitude = result["latitude"]
                let longitude = result["longitude"]
                self.homeAnnotation.coordinate.latitude = latitude as! CLLocationDegrees
                self.homeAnnotation.coordinate.longitude = longitude as! CLLocationDegrees
                self.homeAnnotation.title = "Home :)"
                self.locationsView.addAnnotation(self.homeAnnotation)
                
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didUpdateLocation(locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            locationsView.setRegion(region, animated: true)
        }
    }
    
    func setAsHome(sender: UIButton){
       
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
extension LocationsViewController: MapSearchHandler {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        //locationsView.removeAnnotations(locationsView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        locationsView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        locationsView.setRegion(region, animated: true)
    }
}

extension LocationsViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        //log.debug("called for user location")
       
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.redColor()
        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        //button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        //button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = buttonForAccessoryView()
        return pinView
    }
    
    private func buttonForAccessoryView() -> UIButton{
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        //button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        //button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
       return button
    }
    
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        if let view = mapView.viewForAnnotation(mapView.userLocation){
//            let smallSquare = CGSize(width: 30, height: 30)
//            let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
            //button.setBackgroundImage(UIImage(named: "home-icon"), forState: .Normal)
            //button.addTarget(self, action: #selector(setAsHome), forControlEvents: .TouchUpInside)
            view.leftCalloutAccessoryView = buttonForAccessoryView()
            
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        log.debug("home!")
        let button = view.leftCalloutAccessoryView as! UIButton
        if imageToggle == false{
            
            button.setBackgroundImage(UIImage(named: "home-icon"), forState: .Normal)
            let annotation = view.annotation
            let latitude = annotation?.coordinate.latitude
            let longitude = annotation?.coordinate.longitude
            //store in firebase
            let dict: [String:AnyObject] = [
                "latitude": latitude!,
                "longitude": longitude!
            ]
            FirebaseDataService.dataService.storeHomeCoordinates(dict)
            
            //set home object properties
            Home.sharedInstance.coordinate = annotation?.coordinate
            //start monitoring region
            let region = LocationManager.sharedInstance.regionWithCoordinates(Home.sharedInstance.coordinate!, identifier: Home.sharedInstance.identifier!, notifyOnExit: Home.sharedInstance.notifyOnExit, notifyOnEntry: Home.sharedInstance.notifyOnEntry)
            LocationManager.sharedInstance.startMonitoringRegion(region)
            
            imageToggle = true
        }else{
            let dict: [String:AnyObject] = [
                "latitude": 0,
                "longitude": 0
            ]
            FirebaseDataService.dataService.storeHomeCoordinates(dict)
            button.setBackgroundImage(nil, forState: .Normal)
            
            LocationManager.sharedInstance.stopMonitoringRegion(Home.sharedInstance.identifier!)
            imageToggle = false
        }
    }
}



protocol MapSearchHandler {
    func dropPinZoomIn(placemark: MKPlacemark)
}
