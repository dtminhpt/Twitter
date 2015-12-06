//
//  Tweet.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/27/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var numberOfRetweets: Int?
    var numberOfFavorites: Int?
    
    var id: String?
    var isRetweeted: Bool = false
    var retweetName: String?
    
    var favorited: Bool = false
    var retweeted: Bool = false
    
    init(dictionary: NSDictionary) {
        if dictionary["reweeted_status"] != nil {
            let retweetUser = User(dictionary: dictionary["user"] as! NSDictionary)
            self.retweetName = retweetUser.name
            
            // var dic = dictionary["retweeted_status"] as! NSDictionary
            self.isRetweeted = true
        }

        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id_str"] as? String
      
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        self.numberOfFavorites = dictionary["favorite_count"] as? Int
        self.numberOfRetweets = dictionary["retweet_count"] as? Int
        self.favorited = dictionary["favorited"] as! Bool
        self.retweeted = dictionary["favorited"] as! Bool
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
       
        for dictionary in array {            
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    /*func updateFromDic(dic: NSDictionary) {
        let tweet = Tweet(dictionary: dic)
        self.id = tweet.id
        self.user = tweet.user
        self.text = tweet.text
        
        self.numberOfRetweets = tweet.numberOfRetweets
        self.numberOfFavorites = tweet.numberOfFavorites
        self.retweeted = tweet.reweeted
        self.favorited = tweet.favorited
    }*/
    func updateFromDic(tweet: Tweet) {
        //let tweet = Tweet(dictionary: dic)
        self.id = tweet.id
        self.user = tweet.user
        self.text = tweet.text
        
        self.numberOfRetweets = tweet.numberOfRetweets
        self.numberOfFavorites = tweet.numberOfFavorites
        self.retweeted = tweet.retweeted
        self.favorited = tweet.favorited
    }
}
