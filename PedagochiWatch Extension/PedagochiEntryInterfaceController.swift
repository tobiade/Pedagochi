//
//  PedagochiEntryInterfaceController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation


class PedagochiEntryInterfaceController: WKInterfaceController {

    @IBOutlet var bloodGlucoseLabel: WKInterfaceLabel!
    @IBOutlet var bloodGlucosePicker: WKInterfacePicker!
    var pickerItems = [WKPickerItem]()
    var pickerItemTitles = [String]()
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        createBloodGlucosevalues()
        bloodGlucosePicker.setItems(pickerItems)
        
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
    
    @IBAction func pickerChanged(value: Int) {
        bloodGlucoseLabel.setText(pickerItemTitles[value])
    }
    func createBloodGlucosevalues(){
        for i in 0 ..< 100 {
            let pickerItem = WKPickerItem()
            let pickerValue = String(i)
            pickerItemTitles.append(pickerValue)
            
            pickerItem.title = pickerValue
            pickerItems.append(pickerItem)
            
        }
    }

}
