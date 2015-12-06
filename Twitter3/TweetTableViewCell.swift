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
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetName: UILabel!
    
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
    func updateUI(tweet: Tweet) {
        self.tweet = tweet
        //self.profileImage.setImageWithURL((tweet.user?.profileImageUrl)!)
        self.profileImage.setImageWithURL((tweet.user?.profileImageUrl)!)
        //self.profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        self.nameLabel.text = tweet.user?.name
        
        //self.screennameLabel.text = "@\(newValue!.user!.screenname)"
        self.screennameLabel.text = "@" + (tweet.user?.screenname)!
        self.tweetTextLabel.text = tweet.text
        self.timeLabel.text = tweet.createdAt?.timeAgo()
        
        if tweet.isRetweeted {
            self.retweetName.text = "\(tweet.retweetName!) reweeted"
        } else {
            //do nothing
        }
        
        self.retweetButton.enabled = tweet.user?.screenname! != User.currentUser!.screenname
        //self.updateImage()
        self.updateImageRetweet()
    }
    
    func updateImage() {
        self.favoriteButton.setImage(UIImage(named: tweet!.favorited ? "like-action-on" : "like-action"), forState: UIControlState.Normal)
        self.retweetButton.setImage(UIImage(named: tweet!.retweeted ? "retweet-action-on" : "retweet-action"), forState: UIControlState.Normal)
       }
    
    func updateImageRetweet() {
        if self.tweet?.retweeted == true  {
            self.retweetButton.setImage(UIImage(named: tweet!.retweeted ? "retweet-action-on" : "retweet-action"), forState: UIControlState.Normal)
        }
    }
    
    func updateImageFavorite() {
        self.favoriteButton.setImage(UIImage(named: tweet!.favorited ? "like-action-on" : "like-action"), forState: UIControlState.Normal)
        
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
    

    @IBAction func onReply(sender: AnyObject) {
        delegate?.tweetTableViewCell(self, replyTo: self.tweet!)
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        //let tweet = Tweet(dictionary: response as! NSDictionary)
        if let tweet = tweet {
            print(tweet.id!)
            print((tweet.user?.screenname)!)
           

            TwitterClient.sharedInstance.retweet(tweet.id!) { (tweet, error) -> () in
                if error == nil {
                    //let dic = Dictionary(tweet: Tweet as! Tweet)
                    
                    self.tweet?.updateFromDic(tweet!)
                    self.updateUI(self.tweet!)
                    self.updateImageRetweet()
                    
                    //self.retweetName.text = "\(tweet!.retweetName!) reweeted"
                }
            }
        } else {
            //unweet
            TwitterClient.sharedInstance.unretweet(tweet!.id!) { (tweet, error) -> () in
                if error == nil {
                    //let dic = Dictionary(tweet: Tweet as! Tweet)

                    self.tweet?.updateFromDic(tweet!)
                    //self.updateUI(tweet!)
                    self.tweet?.numberOfRetweets  = (self.tweet?.numberOfRetweets)! - 1
                    if self.tweet?.numberOfRetweets < 0 {
                        self.tweet?.numberOfRetweets = 0
                    }
                    self.tweet?.retweeted = false
                    self.updateUI(self.tweet!)
                    self.updateImageRetweet()
               }
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.favorited == false {
                TwitterClient.sharedInstance.favorite(tweet.id!) { (tweet, error) -> () in
                    if error == nil {
                        //let dic = Dictionary(tweet: Tweet as! Tweet)
                        self.tweet?.updateFromDic(tweet!)
                        self.updateUI(self.tweet!)
                       // self.updateImage()
                        self.updateImageFavorite()
                    }
                }
            } else {
                //unfavorite
                TwitterClient.sharedInstance.unfavorite(tweet.id!) { (tweet, error) -> () in
                    if error == nil {
                        //let dic = Dictionary(tweet: Tweet as! Tweet)
                        self.tweet?.updateFromDic(tweet!)
                        self.tweet?.favorited = false
                        self.updateUI(self.tweet!)
                        self.updateImageFavorite()

                       // self.updateImage()
                    }
                }
            }
            
        }
    }
}
