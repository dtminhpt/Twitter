//
//  TweetsViewController.swift
//  Twitter3
//
//  Created by Dinh Thi Minh on 11/28/15.
//  Copyright © 2015 Dinh Thi Minh. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    
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
        //tableView.rowHeight = UITableViewAutomaticDimension
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
            }
            
            self.tweets = tweets
           // self.tableView.reloadData()
            
            
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
    

    
    @IBAction func onThoat(sender: AnyObject) {
        print("logout")
        
        User.currentUser?.logout()
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        print("logout")
        
        User.currentUser?.logout()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        return cell
   }
    
    //Chon 1 row trong table -> hien thi chi tiet row do / goi viewcontroller khac bang lenh
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TweetView") as! TweetDetailViewController
       
        
            controller.tweet = self.tweets![indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
           // print("Thuc hien select row ")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(tweets!.count)

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

}
