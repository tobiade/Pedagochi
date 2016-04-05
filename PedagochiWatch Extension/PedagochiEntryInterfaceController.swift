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

    @IBOutlet var bloodGlucosePicker: WKInterfacePicker!
    var pickerItems = [WKPickerItem]()
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
    
    func createBloodGlucosevalues(){
        for i in 0 ..< 100 {
            let pickerItem = WKPickerItem()
            pickerItem.title = String(i)
            pickerItems.append(pickerItem)
        }
    }

}
