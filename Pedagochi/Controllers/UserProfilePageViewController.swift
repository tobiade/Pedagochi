//
//  UserProfilePageViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 30/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Eureka
import XCGLogger
class UserProfilePageViewController: FormViewController {
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    let log = XCGLogger.defaultInstance()
    
    let imageName = "profilePic.png"
    var imagePath: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePath = FileManager.sharedInstance.fileNameInDocumentsDirectory(imageName)
        setupUserProfileForm()
        
        GeocodingManager.sharedInstance.testGeoCoder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUserProfileForm(){
        //make circular image in image row when cell updated
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        //form setup
        form +++ Section("My Information")
            <<< ImageRow("profilePicture"){
                $0.title = "Profile Picture"
                }.onChange({
                    row in
                    
                    if let image = row.value{
                            //FileManager.sharedInstance.saveImage(image as UIImage, path: self.imagePath!)
                        self.setImageValue(image as UIImage, key: ProfileSettings.ProfilePicture.rawValue)
                    }else{
                        self.setRowValue(nil, key: ProfileSettings.ProfilePicture.rawValue)
                        //FileManager.sharedInstance.removeFileAtPath(self.imagePath!)
                    }
                    //self.setRowValue(row.value, key: ProfileSettings.ProfilePicture.rawValue)
                    
                }).cellSetup({
                    cell, row in
                    if let _ = self.userDefaults.objectForKey(ProfileSettings.ProfilePicture.rawValue){
                        row.value = self.retrieveImageValue(ProfileSettings.ProfilePicture.rawValue)

                    }
                    
                        //row.value = FileManager.sharedInstance.loadImageFromPath(self.imagePath!)
                })
            <<< NameRow("firstName"){
                $0.title = "First Name"
                //$0.value = NSDate()
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.FirstName.rawValue)
                    User.sharedInstance.firstName = row.value
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.FirstName.rawValue) as? String
                })
            <<< NameRow("lastName"){
                $0.title = "Last Name"
               // $0.value = NSDate()
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.LastName.rawValue)
                    User.sharedInstance.lastName = row.value
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.LastName.rawValue) as? String
                })
            <<< EmailRow("emailAddress"){
                $0.title = "Email"
                //$0.value = ""
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.EmailAddress.rawValue)
                    User.sharedInstance.emailAddress = row.value

                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.EmailAddress.rawValue) as? String
                    
                })
            
            <<< SegmentedRow<String>("gender"){
                $0.title = "Gender"
                $0.options = ["Male", "Female"]
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.Gender.rawValue)
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.Gender.rawValue) as? String
                })
            <<< PostalAddressRow("address"){
                $0.title = "Address"
                $0.streetPlaceholder = "Address Line 1"
                $0.statePlaceholder = "Address Line 2"
                $0.postalCodePlaceholder = "Postcode"
                $0.cityPlaceholder = "City"
                $0.countryPlaceholder = "Country"
                
                $0.value = PostalAddress(
                    street: "Dr. Mario Cassinoni 1011",
                    state: nil,
                    postalCode: "11200",
                    city: "Montevideo",
                    country: "Uruguay"
                )
                
                }.onChange({
                    row in
                    if let address = row.value {
                        self.setPostalAddressRow(address)
                        self.log.debug("address block called")
                    }
                }).cellSetup({
                    cell, row in
                    row.value = self.getPostalAddressRow()
                })
//            <<< LocationRow(){
//                $0.title = "LocationRow"
//                //$0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
//                $0.hidden = .Function(["address"], { form -> Bool in
//                    let row: RowOf<Bool>! = form.rowByTag("address")
//                    if let value = row.value{
//                        return true
//                    }else{
//                        return false
//                    }
//                })
//            }
        +++ Section("Diagnosis")
            <<< PushRow<String>("diagnosis"){
                $0.title = "Diagnosis"
                $0.options = ["Type 1 Diabetes", "Type 2 Diabetes"]
                //$0.
                $0.selectorTitle = "Please select a diagnosis"
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.Diagnosis.rawValue)
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.Diagnosis.rawValue) as? String
                })
        +++ Section("Goals")
            <<< DecimalRow("lowerboundBG"){
                $0.title = "Min. Blood Glucose"
                
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.MinimumBG.rawValue)
                    User.sharedInstance.lowerBoundBG = row.value!
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.MinimumBG.rawValue) as? Double
                    if row.value == nil {
                        row.value = DefaultBloodGlucoseLevel.LowerBound.rawValue
                    }
                })
            <<< DecimalRow("upperBoundBG"){
                $0.title = "Max. Blood Glucose"
                
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.MaximumBG.rawValue)
                    User.sharedInstance.upperBoundBG = row.value!
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.MaximumBG.rawValue) as? Double
                    if row.value == nil{
                        row.value = DefaultBloodGlucoseLevel.UpperBound.rawValue
                    }
                })
            <<< IntRow("minimumCarbsPerDay"){
                $0.title = "Min. Carbs Per Day"

                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.MinimumCarbsPerDay.rawValue)
                    User.sharedInstance.lowerBoundCarbs = Double(row.value!)
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.MinimumCarbsPerDay.rawValue) as? Int
                    if row.value == nil{
                        row.value = Int(DefaultCarbsLevel.LowerBound.rawValue)
                    }
                })
            <<< IntRow("maximumCarbsPerDay"){
                $0.title = "Max. Carbs Per Day"
                
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.MaximumCarbsPerDay.rawValue)
                    User.sharedInstance.upperBoundCarbs = Double(row.value!)
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.MaximumCarbsPerDay.rawValue) as? Int
                    if row.value == nil{
                        row.value = Int(DefaultCarbsLevel.UpperBound.rawValue)
                    }
                })
            <<< IntRow("stepsGoal"){
                $0.title = "Steps Goal Per Day"
                
                }.onChange({
                    row in
                    self.setRowValue(row.value, key: ProfileSettings.StepsPerDayGoal.rawValue)
                    User.sharedInstance.stepsPerDayGoal = Double(row.value!)
                }).cellSetup({
                    cell, row in
                    row.value = self.getRowValue(ProfileSettings.StepsPerDayGoal.rawValue) as? Int
                    if row.value == nil{
                        row.value = Int(DefaultStepsPerDay.RecommendedSteps.rawValue)
                    }
                })
       
        
     
        
    }
    
    private func setRowValue(value: AnyObject?, key: String){
        userDefaults.setObject(value, forKey: key)
    }
    private func getRowValue(key: String) -> AnyObject?{
        guard let value = userDefaults.objectForKey(key) else{
            return nil
        }
        return value
    }
    private func setImageValue(image: UIImage, key:String){
        userDefaults.setObject(UIImagePNGRepresentation(image), forKey: key)
    }
    private func retrieveImageValue(key:String) -> UIImage?{
        var imageData: NSData? = userDefaults.objectForKey(key) as? NSData
        return UIImage(data: imageData!)
    }
    private func setPostalAddressRow(postalAddress: PostalAddress){
        let addressLine1 = postalAddress.street
        userDefaults.setObject(addressLine1, forKey: ProfileSettings.AddressLine1.rawValue)
        let addressLine2 = postalAddress.state
        userDefaults.setObject(addressLine2, forKey: ProfileSettings.AddressLine2.rawValue)
        let city = postalAddress.city
        userDefaults.setObject(city, forKey: ProfileSettings.City.rawValue)
        let postcode = postalAddress.postalCode
        userDefaults.setObject(postcode, forKey: ProfileSettings.Postcode.rawValue)
        let country = postalAddress.country
        userDefaults.setObject(country, forKey: ProfileSettings.Country.rawValue)
        
        
    }
    private func getPostalAddressRow() -> PostalAddress{
        var postalAddress = PostalAddress()
        postalAddress.street = userDefaults.objectForKey(ProfileSettings.AddressLine1.rawValue) as? String
        postalAddress.state = userDefaults.objectForKey(ProfileSettings.AddressLine2.rawValue) as? String
        postalAddress.city = userDefaults.objectForKey(ProfileSettings.City.rawValue) as? String
        postalAddress.postalCode = userDefaults.objectForKey(ProfileSettings.Postcode.rawValue) as? String
        postalAddress.country = userDefaults.objectForKey(ProfileSettings.Country.rawValue) as? String
        return postalAddress
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


