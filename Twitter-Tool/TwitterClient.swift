//
//  TwitterClient.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 10/31/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "tjUJJp5tfS0up3wVXfdzgYGxD", consumerSecret: "uj9izcnayoys7U2Rbc5iRoRnuKJg3BWKxrzhyLGb897Se2omit")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func retweet(with id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionary = response as! [String: AnyObject]
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("retweet error: \(error.localizedDescription)")
            failure(error)
        })

    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: Error) in
                self.loginFailure?(error)
                
            })
            
        }, failure: {(error: Error?) -> Void in
            print("Error - handleOpenUrl: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        let twitterCallbackURL = URL(string: "twitterdemo://oauth")
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: twitterCallbackURL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")
            
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            print("Token Received: \((requestToken?.token)!)" )
            
        }, failure: { (error: Error?) in
            print("Login Error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil 
        deauthorize()
        
        NotificationCenter.default.post(name: User.logoutNotification, object: nil)
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [[String: AnyObject]]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> () ) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            let user = User(dictionary: response as! [String: AnyObject])
            
            success(user)
            print("Name: \(user.name!)")
            print("ScreenName: \(user.screenName!)")
            print("TagLine: \(user.tagline!)")
            print("ProfileURL: \(user.profileUrl!)")
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            print("CurrentAccount() Failure -----: \(error.localizedDescription)")
            failure(error)
        })
        
    }
    
}
