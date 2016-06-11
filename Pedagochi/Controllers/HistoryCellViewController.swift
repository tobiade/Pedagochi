//
//  HistoryCellViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 12/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import MapKit
import XCGLogger
import AFDateHelper
class HistoryCellViewController: UITableViewController {
    var log = XCGLogger.defaultInstance()
    var pedagochiEntry:PedagochiEntry?
    
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var basalLabel: UILabel!
    @IBOutlet weak var bolusLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var bloodGlucoseLabel: UILabel!
    
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var additionalDetailsTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg12"))

        
        setupTableEntries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableEntries(){
        if let time = pedagochiEntry?.entryTimeEpoch{
            timeLabel.text = createTimeLabel(time)
        }else{
            timeLabel.text = "-"
        }
        if let bgLevel = pedagochiEntry?.bloodGlucoseLevel{
            bloodGlucoseLabel.text = String(bgLevel) + "mmol/L"
        }else{
            bloodGlucoseLabel.text = "-"
        }
        if let carbs = pedagochiEntry?.carbs{
            carbsLabel.text = String(carbs) + "g"
        }else{
            carbsLabel.text = "-"
        }
        if let pictureString = pedagochiEntry?.picture{
            let decodedData = NSData(base64EncodedString: pictureString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            //log.debug(decodedData)
           foodImageView.image = UIImage(data: decodedData!)
        }else{
           // carbsLabel.text = "-"
        }
        if let additionalDetails = pedagochiEntry?.additionalDetails{
            additionalDetailsTextView.text = additionalDetails
        }else{
            additionalDetailsTextView.text = "No notes entered"
        }
        var location: CLLocation?
        if let latitude = pedagochiEntry?.latitude, longitude = pedagochiEntry?.longitude{
            location = CLLocation(latitude: latitude, longitude: longitude)
            centreMapOnLocation(location!)
        }else{
            mapView.hidden = true
        }
        if let bolusInsulin = pedagochiEntry?.bolusInsulin{
            bolusLabel.text = String(bolusInsulin) + " units"
        }else{
            bolusLabel.text = "-"
        }
        if let basalInsulin = pedagochiEntry?.basalInsulin{
            basalLabel.text = String(basalInsulin) + " units"
        }else{
            basalLabel.text = "-"
        }
        if let stepsTaken = pedagochiEntry?.stepsTaken{
            stepsLabel.text = String(stepsTaken)
        }else{
            stepsLabel.text = "-"
        }
    }
    
    private func createTimeLabel(epochTime:Double) -> String{
        let nsDateTime = NSDate(timeIntervalSince1970: epochTime)
        let dateString = nsDateTime.toString(dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return dateString
    }
    
    private func centreMapOnLocation(location: CLLocation){
        let regionradius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionradius, regionradius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate
        point.title = "I was here"
        mapView.addAnnotation(point)
        
    }

    @IBAction func editButtonClicked(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newPedagochiEntryNavigationVC = storyboard.instantiateViewControllerWithIdentifier("entryNav") as! UINavigationController
        let newPedagochiEntryVC = newPedagochiEntryNavigationVC.viewControllers.first as! NewBGEntryViewController
        newPedagochiEntryVC.setupFormWithPreExistingValues = true
        newPedagochiEntryVC.pedagochiEntry = pedagochiEntry
        self.navigationController?.pushViewController(newPedagochiEntryVC, animated: true)
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
