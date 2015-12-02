//
//  TweetsViewController.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/28/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var temptweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        
        NSNotificationCenter.defaultCenter().addObserverForName(TwitterEvents.StatusPosted, object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let tweet = notification.object as! Tweet
            self.tweets?.insert(tweet, atIndex: 0)
            self.tableView.reloadData()
            
        }
        loadTweets()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //Dynamic cell
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
    
            TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
                self.loadTweets()

            })
        }
    }
    
    func loadTweets() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            
            //pull to refresh-> keo xong roi thi ngung: khong load mai
            if self.tableView.pullToRefreshView != nil {
            self.tableView.pullToRefreshView.stopAnimating()
                //tableView.showsPullToRefresh = NO;
               //self.tableView.showsPullToRefresh = false
            self.tableView.pullToRefreshView.hidden = false
                
            }
            
            self.tweets = tweets
            self.tableView.reloadData()
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
                return ()
            })
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onLogout(sender: AnyObject) {
        print("logout")
        
        User.currentUser?.logout()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetTableViewCell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)  as! TweetTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
    //Chon 1 row trong table -> hien thi chi tiet row do / goi viewcontroller khac bang lenh
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TweetView") as! TweetDetailViewController
       
        
            controller.tweet = self.tweets![indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
        
    }
    
   /* func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
    }
    //Chinh do rong Row co dinh = 200
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }*/
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   
         if  let navigationController = segue.destinationViewController as? UINavigationController {
            if let tweetReply = navigationController.topViewController as? ReplyViewController {
              
                //let tweet = sender as! Tweet
                
                
                tweetReply.targetUserName = "@" + (User.currentUser!.screenname)!//"@\(temptweet!.user?.screenname)"
               //self.screennameLabel.text = "@" + (User.currentUser!.screenname)!

                
                tweetReply.id = temptweet!.id!
               
           }
        }
    }
    
}

extension   TweetsViewController: TweetTableViewCellDelegate {
    //TweetTableViewCellDelegate
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, replyTo tweet: Tweet) {
        
        temptweet = tweet
        self.performSegueWithIdentifier("TweetReply", sender: temptweet)
        
    }
    
}

/*extension TweetsViewController:ReplyViewControllerDelegate {
    
    func replyView(replyViewController: ReplyViewController, response: NSDictionary?) {
        if response != nil {
            self.tweets?.insert(Tweet(dictionary: response!), atIndex: 0)
            
            self.tableView.reloadData()
        }
    }
    
}*/



