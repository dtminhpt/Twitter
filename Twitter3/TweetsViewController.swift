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
    
    //Add varibale to infinite loading
    var tableFooterView: UIView!
    var loadingView: UIActivityIndicatorView!
    var notificationLabel: UILabel!
    
    
    var maxId: String?
    var loadingMoreResult = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        
        NSNotificationCenter.defaultCenter().addObserverForName(TwitterEvents.StatusPosted, object: nil, queue: nil) { (notification: NSNotification) -> Void in
            let tweet = notification.object as! Tweet
            self.tweets?.insert(tweet, atIndex: 0)
            self.tableView.reloadData()
        }
        
        //Add infinite loading 
        addTableFooterView()
        
        loadTweets()
        //print(tweets!.count!)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        
        //Dynamic cell
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: INFINITE LOADING
    //Add to infinite loading
    override func viewWillAppear(animated: Bool) {
        self.loadingView.hidden = true
        self.loadingView.startAnimating()
        self.loadingMoreResult = false
    }
    func addTableFooterView() {
        
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50))
        print("width: \(tableFooterView.frame.width)")
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        
        notificationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50))
        notificationLabel.text = "No more tweets"
        notificationLabel.textAlignment = NSTextAlignment.Center
        notificationLabel.hidden = true
        tableFooterView.addSubview(notificationLabel)
        
        tableView.tableFooterView = tableFooterView
    }
   /* override func viewDidLayoutSubviews() {
        // When rotate device
        
        // Change size of the loading icon
        tableFooterView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50)
        notificationLabel.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.superview!.frame), height: 50)
        loadingView.center = tableFooterView.center
    }*/
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
    
            TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
                self.loadTweets()
            })
        }
    }
    
    
    //Dismiss editing
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func loadTweets(maxId: String = "") {
        var params: NSDictionary = NSDictionary()
        if maxId.isEmpty == false {
            params = ["max_id": maxId]
        } else {
            //refreshControl
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
        TwitterClient.sharedInstance.homeTimeLineWithParams(params, completion: { (tweets, error) -> () in

            
            //pull to refresh-> keo xong roi thi ngung: khong load mai
            if self.tableView.pullToRefreshView != nil {
            self.tableView.pullToRefreshView.stopAnimating()
                
            self.tableView.pullToRefreshView.hidden = false
            }
            
            
            if maxId.isEmpty == false {
                if var tweets = tweets {
                    tweets.removeFirst()
                    self.tweets?.appendContentsOf(tweets)
                }
            } else {
                self.tweets = tweets
            }
            
            self.loadingMoreResult = false
            self.tableView.reloadData()
            
            self.updateMaxId()
            
            self.loadingView.hidden = true
            self.loadingView.startAnimating()
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
                return ()
            })
        })
    }
    
    func updateMaxId() {
        if let lastTweet = self.tweets?.last {
            self.maxId = lastTweet.id
        }
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
        
        //Add infinite loading
        if indexPath.row == tweets!.count - 1 {
           loadingView.startAnimating()
            
            notificationLabel.hidden = true
            self.loadingView.hidden = false
            self.loadingView.startAnimating()
            self.loadTweets(self.maxId!)
            self.loadingMoreResult = true
            
           // getMoreTweets()
       }
        

        return cell
    }
    
 /*   func getMoreTweets() {
        
        
        
        if tweets!.count > 0 {
            
            let maxId =((tweets[tweets!.count - 1].id)!).longLongValue - (NSNumber(integer: 1).longLongValue)) as NSNumber
        
            
            
            TwitterClient.sharedInstance.homeTimelineWithParams(20, maxId: maxId, completion: { (tweets, error) -> () in
                
                let newTweets = tweets!
                
                for tweet in newTweets {
                    
                    self.tweets.append(tweet)
                    
                }
                
                self.tableView.reloadData()
                
                
                
                print(error)
                
            })
            
        }
        
    }*/
    
    //Chon 1 row trong table -> hien thi chi tiet row do / goi viewcontroller khac bang lenh
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TweetView") as! TweetDetailViewController
       
        
            controller.tweet = self.tweets![indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
        print(self.tweets?.count)
    }
    
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
                tweetReply.targetUserName = "@" + (temptweet!.user?.screenname)!
                //"@\(temptweet!.user?.screenname)"
                
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



