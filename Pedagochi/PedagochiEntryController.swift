//
//  ViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 12/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import Validator
class PedagochiEntryController: FormViewController {
    let pedagochiEntryReference = Firebase(url: "https://brilliant-torch-960.firebaseio.com/pedagochi-entries")
    
    var pedagochiEntry:PedagochiEntry?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setup 'accept'button on right hand side of nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Accept", style: UIBarButtonItemStyle.Plain, target: self, action: "doSomething")
        //form setup
        form +++ Section("Pedagochi Entry")
            <<< DecimalRow("bloodGlucoseLevel"){
                $0.title = "Blood Glucose"
                $0.placeholder = "mmol/L"
                let formatter = NSNumberFormatter()
                formatter.positiveSuffix = " mmol/L"
                $0.formatter = formatter
        }
            <<< IntRow("carbs"){
                $0.title = "Carbs"
                $0.placeholder = "g"
                let formatter = NSNumberFormatter()
                formatter.positiveSuffix = "g"
                $0.formatter = formatter
        }
            <<< TextRow("mealDescription"){
                $0.title = "Meal description"
                $0.placeholder = "Meal details"
        }
        // Do any additional setup after loading the view, typically from a nib.
        

        
    }
    
    func doSomething(){
        let formDict = form.values()
        let pedagochiEntry = PedagochiEntry()
        pedagochiEntry.bloodGlucoseLevel = formDict["bloodGlucoseLevel"] as? Float
        pedagochiEntry.carbs = formDict["carbs"] as? Int
        pedagochiEntry.mealDescription = formDict["mealDescription"] as? String
        print(pedagochiEntry.bloodGlucoseLevel)
        
       let pedagochiEntryRef = self.pedagochiEntryReference.childByAppendingPath("entry1")
        pedagochiEntryRef.setValue(pedagochiEntry.toAnyObject())
        
    }
    func validateFormEntries(dict: Dictionary<String,Any?>){
        let digitRule = ValidationRulePattern(pattern: .ContainsNumber, failureError: ValidationError(message: "😫"))
      //  Validator.validate(input: dict["bloodGlucoseLevel"] as? Float, rule: digitRule)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



