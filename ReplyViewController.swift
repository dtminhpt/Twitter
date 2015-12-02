//
//  ReplyViewController.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 12/2/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit
/*protocol ReplyViewControllerDelegate {
    func replyView(replyViewController: ReplyViewController,response: NSDictionary?)
}*/

class ReplyViewController: UIViewController, UITextViewDelegate {
       let MAX_CHARACTERS_ALLOWED = 140
       // var delegate: ReplyViewControllerDelegate?
        var id: String = ""
        var targetUserName: String = ""

    
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var profileImage: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var textView: UITextView!
        @IBOutlet weak var screennameLabel: UILabel!
        //@IBOutlet weak var remainingCharacterLabel1: UILabel!
        
        @IBOutlet weak var remainingCharacterLabel: UITextField!
        //@IBOutlet weak var remainingCharacterLabel: UITextField!
        override func viewDidLoad() {
            super.viewDidLoad()
    
    
          // Do any additional setup after loading the view.
            self.textView.delegate = self
            self.textView.text = "\(targetUserName)"
            
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
        func countElements(str: String) () -> Int
        {
            return str.characters.count
        }
        
        
        
        func textViewDidChange(textView: UITextView) {
            
            let status = textView.text
            
            let charactersRemaining = MAX_CHARACTERS_ALLOWED - countElements(status)()
            
            self.remainingCharacterLabel.text = "\(charactersRemaining)"
            
            /*if charactersRemaining >= 0{
            self.remainingCharacterLabel.textColor = UIColor.lightGrayColor()
            } else {
            self.remainingCharacterLabel.textColor = UIColor.redColor()
            }*/
            
            self.remainingCharacterLabel.textColor = charactersRemaining >= 0 ? UIColor.lightGrayColor() : UIColor.redColor()
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
        
        
    @IBAction func onReply(sender: AnyObject) {
            let status = self.textView.text
        
            print(countElements(status)())
            if (countElements(status)() == 0) {
                return
            }
            
            //let params: NSDictionary = ["tweet": tweet]
            let params: NSDictionary = ["status": status, "in_reply_to_status_id": id]
            
            
            TwitterClient.sharedInstance.replyTweetUpdateWithParams(params, completion: { (status, error) -> () in
                if error != nil {
                    print("error replying status:\(error)")
                    return
                }
                NSNotificationCenter.defaultCenter().postNotificationName(TwitterEvents.StatusPosted, object: status)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            //print("tap Tweet")
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
