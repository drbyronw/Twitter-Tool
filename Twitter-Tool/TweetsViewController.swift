//
//  TweetsViewController.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 11/2/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)

        tableView.insertSubview(refreshControl, at: 1)
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()

        }, failure: { (error: Error) in
            print("HomeTimeLineError: \(error.localizedDescription)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
        }, failure: { (error: Error) in
            print("HomeTimeLineError: \(error.localizedDescription)")
        })

        print("Performed Refresh")
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            print("# Tweets: \(tweets.count)")
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets?[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    func viewProfile(_ sender: TweetCell) {
        performSegue(withIdentifier: "ProfileViewSegue", sender: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TweetDetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweetsDetailsViewController = segue.destination as! TweetDetailViewController
            tweetsDetailsViewController.tweet = tweets[(indexPath?.row)!]
        } else if segue.identifier == "ComposeSegue" {
            let navigationViewController = segue.destination as! UINavigationController
            let composeViewController = navigationViewController.topViewController as! ComposeViewController
            
            composeViewController.name = User.currentUser?.name
            composeViewController.screenName = User.currentUser?.screenName
            composeViewController.profileURL = User.currentUser?.profileUrl
            
        } else if segue.identifier == "ProfileViewSegue" {
            let navigationController = segue.destination as! UINavigationController
            let profileViewController = navigationController.topViewController as! ProfileViewController
            let cell = sender as! TweetCell
            profileViewController.dismissEnabled = true
            profileViewController.user = cell.tweet.user
            print("Profile Segue")
        }

    }
    

}
