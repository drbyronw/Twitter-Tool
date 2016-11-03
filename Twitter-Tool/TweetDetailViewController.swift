//
//  TweetDetailViewController.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 11/2/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextLabel.text = tweet.text
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = tweet.user?.screenName
        profileImageView.setImageWith((tweet.user?.profileUrl)!)
        timeStampLabel.text = "\(tweet.timeStamp!)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reply(_ sender: Any) {
    }
   
    @IBAction func retweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(with: tweet.tweetID, success: {(tweet: Tweet) in
            print("retweeted: \(self.tweet.text)")
        }, failure: {
            (error: Error) in
            print("Error with Retweet: \(error.localizedDescription)")
        })
    }
    
    
    @IBAction func favorite(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
