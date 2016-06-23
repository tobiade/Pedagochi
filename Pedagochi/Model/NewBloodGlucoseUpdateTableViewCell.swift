//
//  NewsFeedTableViewCell.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 15/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import UIKit
import Spring
class NewBloodGlucoseUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var likeEmoji: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var encourageEmoji: UILabel!
    @IBOutlet weak var encourageCount: UILabel!
    var messageObject: NewsFeedMessage?

    
    
    
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
    
    func hideEmojisAndLabels(){
        likeEmoji.hidden = true
        likeCount.hidden = true
        encourageEmoji.hidden = true
        encourageCount.hidden = true
    }
  
    
    @IBAction func keepItUpButtonTouched(sender: DesignableButton) {
        likeEmoji.hidden = false
        likeCount.hidden = false
        sender.animation = "pop"
        sender.animate()
        guard var upVote = messageObject?.keepItUpCount where upVote >= 1  else{
            let count = 1
            messageObject?.keepItUpCount = count
            likeCount.text = "\(count)"
            FirebaseDataService.dataService.addNewOpinionToNewsFeedItem((messageObject?.messageId)!, action: "keepItUpCount", count: count)
            return
        }
        upVote += 1
        likeCount.text = String(upVote)
        messageObject?.keepItUpCount = upVote
        FirebaseDataService.dataService.addNewOpinionToNewsFeedItem((messageObject?.messageId)!, action: "keepItUpCount", count: (messageObject?.keepItUpCount)!)
        

  
}
@IBAction func doBetterButtonTouched(sender: DesignableButton) {
    encourageEmoji.hidden = false
    encourageCount.hidden = false
    sender.animation = "pop"
    sender.animate()
    guard var upVote = messageObject?.doBetterCount where upVote >= 1 else{
        let count = 1
        messageObject?.doBetterCount = count
        encourageCount.text = "\(count)"
        FirebaseDataService.dataService.addNewOpinionToNewsFeedItem((messageObject?.messageId)!, action: "doBetterCount", count: count)
        return
    }
    upVote += 1
    encourageCount.text = String(upVote)
    messageObject?.doBetterCount = upVote
    FirebaseDataService.dataService.addNewOpinionToNewsFeedItem((messageObject?.messageId)!, action: "doBetterCount", count: (messageObject?.doBetterCount)!)
    
}
}
