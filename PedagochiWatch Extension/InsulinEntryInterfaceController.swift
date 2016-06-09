//
//  InsulinEntryInterfaceController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 06/06/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation


class InsulinEntryInterfaceController: WKInterfaceController,PickerProtocol {

    @IBOutlet var insulinLabel: WKInterfaceLabel!
    
    @IBOutlet var insulinPicker: WKInterfacePicker!
    
    var insulinPickerItems = [WKPickerItem]()
    var insulinPickerItemTitles = [String]()
    
    private var insulinUnits: String?
    var selectedInsulinUnits: String?{
        get{
            return insulinUnits
        }
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        //set reference
        PedagochiWatchEntry.sharedInstance.insulinEntryIC = self
        
        createInsulinValues()
        insulinPicker.setItems(insulinPickerItems)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func createInsulinValues(){
        for i in 0.stride(to: 305, by: 1){
            let pickerItem = WKPickerItem()
            let pickerValue = String(i)
            insulinPickerItemTitles.append(pickerValue)
            
            pickerItem.title = pickerValue
            insulinPickerItems.append(pickerItem)
        }
    }
    
    
    @IBAction func insulinPickerDidChange(value: Int) {
        let valueSelected = insulinPickerItemTitles[value]
        insulinLabel.setText(valueSelected)
        if valueSelected == "0"{
            insulinUnits = nil
        }
        else{
            insulinUnits = valueSelected
            
        }
    }
    
    func returnPickerValue() -> String? {
        return insulinUnits
    }

    @IBAction func doneDidTouch() {
        let dict = PedagochiWatchEntry.sharedInstance.buildDataForStorageInFirebase()
        FirebaseHelper.sharedInstance.persistEntryToFirebase(dict as! [String:AnyObject])
        self.dismissController()

    }
}
