//
//  ProfileViewController.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 11/5/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]!
    var user: User!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    let refreshControl = UIRefreshControl()
    var dismissEnabled: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let dismissEnabled = dismissEnabled {
            dismissButton.isEnabled = dismissEnabled
        } else {
            dismissButton.isEnabled = false
            dismissButton.tintColor = UIColor.clear

        }
        
        self.refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 1)
        

        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("HomeTimeLineError: \(error.localizedDescription)")
        })

        if user != nil {
            setupProfile()
            
        } else {
            user = User.currentUser
            setupProfile()
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfile() {
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName
        locationLabel.text = user.location
        followersLabel.text = "\(user.followersCount)"
        followingLabel.text = "\(user.followingCount)"
        
        headerImageView.setImageWith(user.headerUrl!)
        profileImageView.setImageWith(user.profileUrl!)
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
    
    @IBAction func onDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetDetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweetsDetailsViewController = segue.destination as! TweetDetailViewController
            tweetsDetailsViewController.tweet = tweets[(indexPath?.row)!]
        }
    }
    

}
