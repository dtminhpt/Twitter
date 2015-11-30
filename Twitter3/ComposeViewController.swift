//
//  ComposeViewController.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/29/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    let MAX_CHARACTERS_ALLOWED = 140
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var remainingCharacterLabel1: UILabel!
    
    @IBOutlet weak var remainingCharacterLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profileImage.setImageWithURL((User.currentUser?.profileImageUrl)!)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        
        self.nameLabel.text = User.currentUser?.name
        self.screennameLabel.text = "@" + (User.currentUser!.screenname)!
                
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        
            
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            self.view.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y)
        }
        self.remainingCharacterLabel.text = "\(MAX_CHARACTERS_ALLOWED)"
        self.textView.becomeFirstResponder()
        
    }
    override func viewDidLayoutSubviews() {
        self.adjustScrollViewContentSize()
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let tweet = textView.text
        
        //let charactersRemaining = MAX_CHARACTERS_ALLOWED - countElements(tweet)
        
       // self.remainingCharacterLabel.text = "\(charatersRemaining)"
        //self.remainingCharacterLabel.textColor = charactersRemaining >= 0 ? .lightGrayColor() : .reColor()
        self.adjustScrollViewContentSize()
    }
    func adjustScrollViewContentSize() {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.textView.frame.origin.y + self.textView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancelTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func onTweetTap(sender: AnyObject) {
        let tweet = self.textView.text
        
       // if (countElements(status) == 0) {
         //   return
        //}
    
        let params: NSDictionary = ["tweet": tweet]
        
        TwitterClient.sharedInstance.postTweetUpdateWithParams(params, completion: { (tweet, error) -> () in
            if error != nil {
                print("error posting tweet:\(error)")
                return
            }
            NSNotificationCenter.defaultCenter().postNotificationName(TwitterEvents.StatusPosted, object: tweet)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        print("tap Tweet")
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
