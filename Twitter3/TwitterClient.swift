//
//  TwitterClient.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/27/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

let twitterConsumerKey = "iPBG3irL4MneVEyqJJoGIfCZs"
let twitterConsumerSecret = "Y9dKWWlh38H3KDT9836xxgVRB8DEKgMOBXg8h2k8uHyGYIj0Eq"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")



class TwitterClient: BDBOAuth1RequestOperationManager {
    class var sharedInstance: TwitterClient {
        
        struct Static {
            
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
       
        return Static.instance
        
    }
 }
