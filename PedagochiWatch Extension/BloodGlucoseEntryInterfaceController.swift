//
//  PedagochiEntryInterfaceController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation


class BloodGlucoseEntryInterfaceController: WKInterfaceController {

    @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    @IBOutlet var bloodGlucosePicker: WKInterfacePicker!
    
    
    var bloodGucosePickerItems = [WKPickerItem]()
    var bloodGlucosePickerItemTitles = [String]()
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

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
        bloodGlucoseLabel.setText(bloodGlucosePickerItemTitles[value])
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
    
 

}
