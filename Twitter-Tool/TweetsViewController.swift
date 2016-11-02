//
//  TweetsViewController.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 11/2/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
//            for tweet in tweets {
//                print(tweet.text ?? "No Tweet")
//                print(tweet.timeStamp ?? "No TimeStamp")
//                print(tweet.favoritesCount, tweet.retweetCount)
//            }
        }, failure: { (error: Error) in
            print("HomeTimeLineError: \(error.localizedDescription)")
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
        
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
