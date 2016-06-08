//
//  InfoCellViewController.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 08/06/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import SSBouncyButton
class InfoCellViewController: UIViewController {

    @IBOutlet weak var dislikeButton: SSBouncyButton!
    @IBOutlet var likeButton: SSBouncyButton!
    @IBOutlet weak var infoTextView: UITextView!
    var info: InfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        infoTextView.text = info?.information!

        // Do any additional setup after loading the view.
        likeButton.setTitle("This information is useful", forState: .Normal)
        likeButton.setTitle("This information is useful", forState: .Selected)
        likeButton.tintColor = UIColor.greenColor()
        likeButton.cornerRadius = 5
        likeButton.addTarget(self, action: #selector(positiveButtonPressed), forControlEvents: .TouchUpInside)
        
        dislikeButton.setTitle("This information is not useful", forState: .Normal)
        dislikeButton.setTitle("This information is not useful", forState: .Selected)
        dislikeButton.tintColor = UIColor.redColor()
        dislikeButton.cornerRadius = 5
        dislikeButton.addTarget(self, action: #selector(negativeButtonPressed), forControlEvents: .TouchUpInside)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    func positiveButtonPressed(button: UIButton){
        button.selected = !button.selected
        if dislikeButton.selected {
            dislikeButton.selected = false
        }
        var dict =  [String:AnyObject]()
        buildRatedDictionary(&dict, info: info!, rating: "positive")
        FirebaseDataService.dataService.addNewRatedDocument(&dict, sentiment: "positive")
        
    }
    
    func negativeButtonPressed(button: UIButton){
        button.selected = !button.selected
        if likeButton.selected {
            likeButton.selected = false
        }
        var dict =  [String:AnyObject]()
        buildRatedDictionary(&dict, info: info!, rating: "negative")
        FirebaseDataService.dataService.addNewRatedDocument(&dict, sentiment: "negative")
    }
    
    func buildRatedDictionary(inout dict: [String:AnyObject], info: InfoModel, rating: String){
        dict["id"] = info.id
        dict["info_type"] = info.infoType
        dict["information"] = info.information
        dict["rating"] = rating
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
