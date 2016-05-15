//
//  NewBGEntryViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 22/03/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import AFDateHelper
import UIKit
import Eureka
import CoreLocation
import XCGLogger
import Firebase
class NewBGEntryViewController: FormViewController, CLLocationManagerDelegate {
    let log = XCGLogger.defaultInstance()
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var currentLocation: CLLocation! {
        didSet{
            log.debug("location updated")
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            let locationRow : LocationRow? = form.rowByTag("location")
            locationRow?.value = CLLocation(latitude: latitude, longitude:longitude )
            locationRow?.updateCell()
        }
      
    }

    var setupFormWithPreExistingValues = false //this property is set by presenting view controller
    var pedagochiEntry: PedagochiEntry? //this property is set by presenting view controller

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup location manager for location row in entry form
        //locationManager = CLLocationManager()
        //locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //checkCoreLocationPermission()

        // Do any additional setup after loading the view.
        if setupFormWithPreExistingValues == true{
            setupEntryFormWithPrePopulatedValues(pedagochiEntry)
        }else{
            setupNewEntryForm()
        }
    }
    
    func checkCoreLocationPermission(){
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .AuthorizedAlways{
            locationManager.startUpdatingLocation()
        }else if authorizationStatus == .NotDetermined{
            locationManager.requestAlwaysAuthorization()
            //if user authorizes, start updating location
            if CLLocationManager.authorizationStatus() == .AuthorizedAlways{
                locationManager.startUpdatingLocation()
            }
        }
        else if authorizationStatus == .Restricted{
            let alertController = UIAlertController(title: "Error", message:
                "Pedagochi not authorised to use location", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            //print("Pedagochi not authorised to use location")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNewEntryForm(){
        //make circular image in image row when cell updated
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        //form setup
        form +++ Section("Pedagochi Entry")
            <<< DateTimeInlineRow("time"){
                $0.title = "Time"
                $0.value = NSDate()
            }
            <<< LocationRow("location"){
                $0.title = "Location"
                $0.value = LocationManager.sharedInstance.currentLocation
            }

            <<< DecimalRow("bloodGlucoseLevel"){
                $0.title = "Blood Glucose"
                $0.placeholder = "mmol/L"
                let formatter = NSNumberFormatter()
               // formatter.locale = .currentLocale()
                formatter.positiveSuffix = " mmol/L"
                $0.formatter = formatter
                $0.useFormatterDuringInput = true

            }
            <<< IntRow("carbs"){
                $0.title = "Carbs"
                $0.placeholder = "g"
                let formatter = NSNumberFormatter()
                //formatter.locale = .currentLocale()
                formatter.positiveSuffix = "g"
                $0.formatter = formatter
                $0.useFormatterDuringInput = true

            }
            <<< ImageRow("picture"){
                $0.title = "Picture"
            }
            <<< TextAreaRow("additionalDetails"){
                //$0.title = "Meal Description"
                $0.placeholder = "Additional Details"
        }

    }
    
    func setupEntryFormWithPrePopulatedValues(entry: PedagochiEntry?){
        //get date and time
        let dateTime = NSDate(timeIntervalSince1970: entry!.entryTimeEpoch!)
        //get location if available
        var location: CLLocation?
        if let latitude = entry?.latitude, longitude = entry?.longitude{
            location = CLLocation(latitude: latitude, longitude: longitude)
        }
        //get blood glucose if available
        var bloodGlucose: Double?
        if let bgLevel = entry?.bloodGlucoseLevel{
            bloodGlucose = bgLevel
        }
        //get carbs if available
        var carbs: Int?
        if let carbsUnwrapped = entry?.carbs{
            carbs = carbsUnwrapped
        }
        //get picture if available
        var picture: UIImage?
        if let pictureString = entry?.picture{
            let decodedData = NSData(base64EncodedString: pictureString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            picture = UIImage(data: decodedData!)
        }
        //get notes if available
        var notes: String?
        if let notesUnwrapped = entry?.additionalDetails{
            notes = notesUnwrapped
        }
        
        //make circular image in image row when cell updated
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        //form setup
        form +++ Section("Pedagochi Entry")
            <<< DateTimeInlineRow("time"){
                $0.title = "Time"
                $0.value = dateTime
            }
            <<< LocationRow("location"){
                $0.title = "Location"
                //location value set in currentLocation didSet property observer
                $0.value = location
            }
            
            <<< DecimalRow("bloodGlucoseLevel"){
                $0.title = "Blood Glucose"
                $0.value = bloodGlucose
                $0.placeholder = "mmol/L"
                let formatter = NSNumberFormatter()
                // formatter.locale = .currentLocale()
                formatter.positiveSuffix = " mmol/L"
                $0.formatter = formatter
                $0.useFormatterDuringInput = true
                
            }
            <<< IntRow("carbs"){
                $0.title = "Carbs"
                $0.value = carbs
                $0.placeholder = "g"
                let formatter = NSNumberFormatter()
                //formatter.locale = .currentLocale()
                formatter.positiveSuffix = "g"
                $0.formatter = formatter
                $0.useFormatterDuringInput = true
                
            }
            <<< ImageRow("picture"){
                $0.title = "Picture"
                $0.value = picture
            }
            <<< TextAreaRow("additionalDetails"){
                //$0.title = "Meal Description"
                $0.value = notes
                $0.placeholder = "Additional Details"
        }
        
    }
    

    @IBAction func cancelDidTouch(sender: AnyObject) {
       
       dismissViewController()
    }
    
    @IBAction func doneDidTouch(sender: AnyObject) {
        //log.debug(form.values().description)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            var data = self.buildDataForStorageInFirebase(self.form.values()) as! [String:AnyObject]
            let date = data["date"] as! String
            
            
            //if form loaded with pre-existing values, we are altering an entry, so perform update operation
            if self.setupFormWithPreExistingValues == true{
                FirebaseDataService.dataService.updatePedagochiEntry(data, withDate: date, withID: (self.pedagochiEntry?.pedagochiEntryID)!)
            }else{
                FirebaseDataService.dataService.addNewPedagochiEntry(&data , date: date)
                let bloodGlucoseLevel = data["bloodGlucoseLevel"] as? Double
                let postBGUpdate = SettingsManager.sharedInstance.postBloodGlucoseUpdatesToNewsFeed

                if bloodGlucoseLevel != nil && postBGUpdate == true{
                    self.postBloodGlucoseUpdateToNewsFeed(bloodGlucoseLevel!)
                }
            }
        }
        
        dismissViewController()

    }
    private func dismissViewController(){
         //pop view controller if this controller pushed by a navigation controller else it was presented modally, so dismiss approporiately
        if self.presentingViewController is UITabBarController{
            log.debug("modal cancel")
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

        }else{
            log.debug("nav bar cancel")
            self.navigationController?.popViewControllerAnimated(true)

        }
    }
    
    //MARK: LocationManager Delegate
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //currentLocation = locations.last
//        //print(currentLocation.coordinate.latitude)
//
//        locationManager.stopUpdatingLocation()
//    }
    
    //MARK: Data transformer
    func buildDataForStorageInFirebase(dict: [String:Any?]) -> [String:AnyObject?]{
        var firebaseData = [String:AnyObject?]()
       addDateAndTime(dict, modifyingDict: &firebaseData)
        addCoordinates(dict, modifyingDict: &firebaseData)
        addBloodGlucose(dict, modifyingDict: &firebaseData)
        addCarbs(dict, modifyingDict: &firebaseData)
        addPicture(dict, modifyingDict: &firebaseData)
        addAdditionalDetails(dict, modifyingDict: &firebaseData)
        addTimestamp(&firebaseData)
        addDevice(&firebaseData)
       // log.debug(firebaseData.description)
        
       return firebaseData
        

    }
    
    func addDateAndTime(formDict: [String:Any?],inout modifyingDict: [String:AnyObject?]){
        let time = formDict["time"] as! NSDate
        let date = time.toString(format: .ISO8601(ISO8601Format.Date))
        modifyingDict["date"] = date
        let hourMinSec = time.toString(format: .Custom("HH:mm"))
        modifyingDict["time"] = hourMinSec
        modifyingDict["entryTimeEpoch"] = time.timeIntervalSince1970
    }
    
    func addCoordinates(formDict: [String:Any?],inout modifyingDict: [String:AnyObject?]){
        let location = formDict["location"] as? CLLocation
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        modifyingDict["latitude"] = latitude
        modifyingDict["longitude"] = longitude

        //log.debug("latitude is \(latitude), longitude is \(longitude)")
    }
    func addBloodGlucose(formDict: [String:Any?],inout modifyingDict: [String:AnyObject?]){
        let bloodGlucose = formDict["bloodGlucoseLevel"] as? Double
        modifyingDict["bloodGlucoseLevel"] = bloodGlucose
        
    }
    func addCarbs(formDict: [String:Any?],inout modifyingDict: [String:AnyObject?]){
        let carbs = formDict["carbs"] as? Int
        modifyingDict["carbs"] = carbs
    }
    func addPicture(formDict: [String:Any?],inout modifyingDict: [String:AnyObject?]){
        let picture = formDict["picture"] as? UIImage
        
        guard picture != nil else{
            modifyingDict["picture"] = nil
            return
        }
        
        let pictureData: NSData = UIImageJPEGRepresentation(picture!, 1)!
        let base64String: String = pictureData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        modifyingDict["picture"] = base64String
    }
    func addAdditionalDetails(formDict: [String:Any?],inout modifyingDict: [String:AnyObject?]){
        let additionalDetails = formDict["additionalDetails"] as? String
        modifyingDict["additionalDetails"] = additionalDetails
    
    }
    func addTimestamp(inout modifyingDict: [String:AnyObject?]){
       // modifyingDict["timestamp"] = FirebaseServerValue.timestamp() //causes value event to be triggered twice
        modifyingDict["clientTimestamp"] = NSDate().timeIntervalSince1970

    }
    
    func addDevice(inout modifyingDict: [String:AnyObject?]){
        modifyingDict["entryDevice"] = "iPhone"
    }
    
    func postBloodGlucoseUpdateToNewsFeed(bgLevel: Double){
        let newMessage: [String:AnyObject?] = [ "message": String(bgLevel),
                                                "postedBy": User.sharedInstance.firstName,
                                                "postedAt": NSDate().timeIntervalSince1970,
                                                "messageType": MessageType.BloodGlucoseUpdate.rawValue,
                                                "uid": FirebaseDataService.dataService.userId]
        
        FirebaseDataService.dataService.postNewMessage(newMessage as! [String:AnyObject])
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
