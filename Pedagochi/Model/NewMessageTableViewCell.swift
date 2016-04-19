//
//  NewMessageTableViewCell.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 17/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func layoutSubviews() {
//        cardViewSetup()
//        profileImageSetup()
//    }

    
    func cardViewSetup(){
        cardView.alpha = 1
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 1
        cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        cardView.layer.shadowRadius = 1
        cardView.layer.shadowOpacity = 0.2
        
        let path = UIBezierPath(rect: cardView.bounds)
        cardView.layer.shadowPath = path.CGPath
        
        
    }
    
    func profileImageSetup(){
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .ScaleAspectFit
        profilePictureImageView.backgroundColor = UIColor.whiteColor()
    }
    
  
}
