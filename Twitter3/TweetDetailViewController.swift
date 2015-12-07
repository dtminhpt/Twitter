//
//  TweetDetailViewController.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/29/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetNumberLabel: UILabel!
    @IBOutlet weak var favoriteNumberLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Tweet"
        
        self.profileImage.setImageWithURL((self.tweet?.user?.profileImageUrl)!)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.nameLabel.text = self.tweet?.user?.name
        //self.screennameLabel.text = "@\(self.tweet?.user?.screenname)"
        self.screennameLabel.text = "@" + (self.tweet?.user?.screenname)!

        self.tweetTextLabel.text = self.tweet?.text
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd yyyy 'at' h:mm aaa"
        self.dateLabel.text = formatter.stringFromDate(self.tweet!.createdAt!)
        
        self.retweetNumberLabel.text = "\((self.tweet!.numberOfRetweets)!)"
        self.favoriteNumberLabel.text = "\((self.tweet!.numberOfFavorites)!)"
        
        print("So reweet\(self.tweet?.numberOfRetweets)- Details 1 cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onReply(sender: AnyObject) {
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
                if  let navigationController = segue.destinationViewController as? UINavigationController {
                    if let tweetReply = navigationController.topViewController as? ReplyViewController {
                            let tweet = sender as! Tweet
    
                            //tweetReply.targetUserName = "@\(tweet.user?.screenname)"
                        
                            tweetReply.targetUserName = self.nameLabel.text!
                            tweetReply.id = tweet.id!    
                    }
            }
    }

}
