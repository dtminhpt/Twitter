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
    var isReweeted: Bool = false
    var retweetName: String?
    
    var favorited: Bool = false
    var reweeted: Bool = false
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        self.numberOfFavorites = dictionary["favorite_count"] as? Int
        self.numberOfRetweets = dictionary["retweet_count"] as? Int
        
        if dictionary["reweeted_status"] != nil {
            let reweetUser = User(dictionary: dictionary["user"] as! NSDictionary)
            self.retweetName = reweetUser.name
            
           // var dic = dictionary["reweeted_status"] as! NSDictionary
            self.isReweeted = true
        }
        //self.id = "\(dic["id"]!)"
        //self.id =  "\(dictionary["id"]!)"
        id = dictionary["id"] as? String
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
       
        for dictionary in array {            
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
