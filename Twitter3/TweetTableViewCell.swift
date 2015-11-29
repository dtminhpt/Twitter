//
//  TweetTableViewCell.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/29/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var tweet: Tweet? {
        willSet(newValue){
            self.profileImage.setImageWithURL((newValue?.user?.profileImageUrl)!)
            self.nameLabel.text = newValue?.user?.name
            //self.screennameLabel.text = "@\(newValue!.user!.screenname)"
            self.screennameLabel.text = "@" + (newValue?.user?.screenname)!
            self.tweetTextLabel.text = newValue?.text
            self.timeLabel.text = newValue?.createdAt?.timeAgo()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
