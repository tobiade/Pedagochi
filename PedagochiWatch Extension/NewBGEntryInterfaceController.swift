//
//  NewBGEntryInterfaceController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 09/06/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import WatchKit
import Foundation


class NewBGEntryInterfaceController: WKInterfaceController {

    @IBOutlet var leftPicker: WKInterfacePicker!
    @IBOutlet var rightPicker: WKInterfacePicker!
    
    var items = [String]()
    //var rightItems = [String]()
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        items = (0...9).map{
            "\($0).png"
        }
//        let pickerItems: [WKPickerItem] = items.map{
//            let pickerItem = WKPickerItem()
//            pickerItem.contentImage = WKImage(imageName: $0)
//            return pickerItem
//        }
                    let pickerItem = WKPickerItem()
                    pickerItem.contentImage = WKImage(imageName: "0-white.png")
        var pickerItems = [WKPickerItem]()
        pickerItems.append(pickerItem)
        
        leftPicker.setItems(pickerItems)
        rightPicker.setItems(pickerItems)
        leftPicker.focus()
        rightPicker.focus()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func rightPickerSelectedItemChanged(value: Int) {
    }

    @IBAction func leftPickerSelectedItemChanged(value: Int) {
    }
}
