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
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
           static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
       
        return Static.instance
    }
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            
            }) { (error: NSError!) -> Void in
                
                print("Failed to get the request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
                print("home timeline:\(response)")
            
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error getting home timeline")
                    
                completion(tweets: nil, error: error)
         })
    }
    
    func postTweetUpdateWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("post tweet thanh cong")
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error posting tweet update")
                
                completion(tweet: nil, error: error)
        })
    }
    
    func replyTweetUpdateWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("reply tweet thanh cong")
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error posting tweet update")
                
                completion(tweet: nil, error: error)
        })
    }
    
    
    func retweet(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("retweet thanh cong")
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error retweetting tweet update")
                print(error)
                
                completion(tweet: nil, error: error)
        })
    }
    
    func unretweet(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id).json?include_my_request=1", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("unretweet thanh cong")
            completion(tweet: tweet, error: nil)
            
            if
            let dic = response as? NSDictionary,
            let current_user_retweet = dic["current_user_retweet"],
            let retweet_id = current_user_retweet["id_str"]
            {
                //1.1/statuses/destroy/:id.json
                TwitterClient.sharedInstance.POST("1.1/statuses/destroy/\(retweet_id!).json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                    
                    let tweet = Tweet(dictionary: response as! NSDictionary)
                    print("unretweet thanh cong")
                    completion(tweet: tweet, error: nil)
                    
                    }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                        print("error unreweetting tweet update")
                        
                        completion(tweet: nil, error: error)
                })
            }
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error reweetting tweet update")
                
                completion(tweet: nil, error: error)
        })
    }
    

    func favorite(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["id": id]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("favorite thanh cong")
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error favorating tweet update")
                
                completion(tweet: nil, error: error)
        })
    }
    
    func unfavorite(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["id": id]
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            print("unfavorite thanh cong")
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("error unfavorating tweet update")
                print(error)
                
                completion(tweet: nil, error: error)
        })
    }


    func openURL(url: NSURL) {
            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query) , success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
                
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                //print("user:\(response)")//lay response
                let user = User(dictionary: response as! NSDictionary)
                print("user: \(user.name)")
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
 }
