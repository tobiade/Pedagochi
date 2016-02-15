//
//  ViewController.swift
//  Pedagochi
//
//  Created by Sarah-Jessica Jemitola on 12/02/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Eureka
class PedagochiEntryController: FormViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setup 'accept'button on right hand side of nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Accept", style: UIBarButtonItemStyle.Plain, target: self, action: "doSomething")
        //form setup
        form +++ Section("Pedagochi Entry")
            <<< DecimalRow(){
                $0.title = "Blood Glucose"
                $0.placeholder = "mmol/L"
                let formatter = NSNumberFormatter()
                formatter.positiveSuffix = " mmol/L"
                $0.formatter = formatter
        }
            <<< IntRow(){
                $0.title = "Carbs"
                $0.placeholder = "g"
                let formatter = NSNumberFormatter()
                formatter.positiveSuffix = "g"
                $0.formatter = formatter
        }
            <<< TextRow(){
                $0.title = "Meal description"
                $0.placeholder = "Meal details"
        }
        // Do any additional setup after loading the view, typically from a nib.
        

        
    }
    
    func doSomething(){
        print("Tapped!!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



