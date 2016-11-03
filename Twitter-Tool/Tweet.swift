//
//  Tweet.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 10/31/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import Foundation

class Tweet {
    var text: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var timeStamp: Date?
    var user: User?
    
    init(dictionary: [String: AnyObject]) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0

        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString)
        }
        
        if let userDictionary = dictionary["user"] as? [String: AnyObject] {
            user = User(dictionary: userDictionary)
        }
    }
    
    class func tweetsWithArray(dictionaries: [[String: AnyObject]]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
