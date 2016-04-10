//
//  PedagochiEntryInterfaceController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation


class BloodGlucoseEntryInterfaceController: WKInterfaceController, PickerProtocol {

    @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    @IBOutlet var bloodGlucosePicker: WKInterfacePicker!
    
    
    var bloodGucosePickerItems = [WKPickerItem]()
    var bloodGlucosePickerItemTitles = [String]()
    
    var delegate: PedagochiWatchEntry?
    
    private var bgLevel: String?
    var selectedBloodGlucoseLevel: String?{
        get{
            return bgLevel
        }
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        //set reference
        PedagochiWatchEntry.sharedInstance.bloodGlucoseEntryIC = self
        
        createBloodGlucosevalues()
        bloodGlucosePicker.setItems(bloodGucosePickerItems)
        
        


        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func bloodGlucosePickerChanged(value: Int) {
        let valueSelected = bloodGlucosePickerItemTitles[value]
        bloodGlucoseLabel.setText(valueSelected)
        if valueSelected == "0"{
            bgLevel = nil
        }
        else{
            bgLevel = valueSelected
            
        }
    }
    
    

    
    func createBloodGlucosevalues(){
        for i in 0 ..< 100 {
            let pickerItem = WKPickerItem()
            let pickerValue = String(i)
            bloodGlucosePickerItemTitles.append(pickerValue)
            
            pickerItem.title = pickerValue
            bloodGucosePickerItems.append(pickerItem)
            
        }
    }
    
    @IBAction func doneDidTouch() {
        let dict = PedagochiWatchEntry.sharedInstance.buildDataForStorageInFirebase()
        FirebaseHelper.sharedInstance.persistEntryToFirebase(dict as! [String:AnyObject])
    }
    
    func returnPickerValue() -> String? {
        return bgLevel
    }
 

}
