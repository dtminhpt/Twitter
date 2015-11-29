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
        
        print("So reweet\(self.tweet?.numberOfRetweets)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
