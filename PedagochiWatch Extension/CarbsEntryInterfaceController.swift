//
//  CarbsEntryInterfaceController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 05/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation


class CarbsEntryInterfaceController: WKInterfaceController {
    @IBOutlet var carbsLabel: WKInterfaceLabel?
    @IBOutlet var carbsPicker: WKInterfacePicker?
    
    var carbsPickerItems = [WKPickerItem]()
    var carbsPickerItemTitles = [String]()



    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        createCarbsValues()
        carbsPicker?.setItems(carbsPickerItems)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func carbsPickerChanged(value: Int) {
        
    }
    
    func createCarbsValues(){
        for i in 0.stride(to: 300, by: 5){
            let pickerItem = WKPickerItem()
            let pickerValue = String(i)
            carbsPickerItemTitles.append(pickerValue)
            
            pickerItem.title = pickerValue
            carbsPickerItems.append(pickerItem)
        }
    }

}
