//
//  TweetTableViewCell.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/29/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit
protocol TweetTableViewCellDelegate {
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, replyTo tweet: Tweet)
}


class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var reweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate:TweetTableViewCellDelegate?
    
    var tweet: Tweet? {
        willSet(newValue){
            self.tweet = newValue
            self.profileImage.setImageWithURL((newValue?.user?.profileImageUrl)!)
            self.nameLabel.text = newValue?.user?.name
            //self.screennameLabel.text = "@\(newValue!.user!.screenname)"
            self.screennameLabel.text = "@" + (newValue?.user?.screenname)!
            self.tweetTextLabel.text = newValue?.text
            self.timeLabel.text = newValue?.createdAt?.timeAgo()
        }
    }
   // var tweet: Tweet?
   /* func updateUI(tweet: Tweet) {
        self.tweet = tweet
        //self.profileImage.setImageWithURL((tweet.user?.profileImageUrl)!)
        self.profileImage.setImageWithURL((tweet.user?.profileImageUrl)!)
        //self.profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        self.nameLabel.text = tweet.user?.name
        //self.screennameLabel.text = "@\(newValue!.user!.screenname)"
        self.screennameLabel.text = "@" + (tweet.user?.screenname)!
        self.tweetTextLabel.text = tweet.text
        self.timeLabel.text = tweet.createdAt?.timeAgo()
        
    }*/
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
    

    @IBAction func onReply(sender: AnyObject) {
        delegate?.tweetTableViewCell(self, replyTo: self.tweet!)
    }
    
}
