//
//  NewsFeedTableViewCell.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 15/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit

class NewBloodGlucoseUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var bloodGlucoseLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
    @IBAction func keepItUpButtonTouched(sender: AnyObject) {
    }

    @IBAction func doBetterButtonTouched(sender: AnyObject) {
    }
}
