//
//  User.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/27/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    //var profileImageURL: String?
    var profileImageUrl: NSURL
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        //profileImageURL = dictionary["profile_image_url"] as? String
        //profileImageUrl = NSURL(string: (dictionary["profile_image_url"] as! String).stringByReplacingOccurrencesOfString("_normal", withString: "_bigger", options: [], range: nil))!
        profileImageUrl = NSURL(string: (dictionary["profile_image_url"] as! String).stringByReplacingOccurrencesOfString("_normal", withString: "_bigger"))!
       
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do{
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        
                         _currentUser = User(dictionary: dictionary)
                    } catch {
                        print("json object with data error")
                    }
        
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do{
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print("json object with data error")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()            
        }
    }
}
