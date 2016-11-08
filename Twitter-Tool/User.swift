//
//  User.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 10/31/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var headerUrl: URL?
    var tagline: String?
    var followersCount: Int = 0
    var followingCount: Int = 0
    var tweetsCount: Int = 0
    var location: String?
    var userID: Int = 0
    
    var dictionary: [String: AnyObject]?
    
    static var _currentUser: User?
    static let logoutNotification = Notification.Name("UserDidLogout")

    
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    if let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: AnyObject] {
                        _currentUser = User(dictionary: dictionary!)
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user 
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        location = dictionary["location"] as? String
        
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
        tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
        userID = (dictionary["id"] as? Int) ?? 0
        
        let profileUrlString = dictionary["profile_image_url"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let profileHeaderString = dictionary["profile_background_image_url"] as? String
        if let profileHeaderString = profileHeaderString {
            headerUrl = URL(string: profileHeaderString)
        }
    }
    
}
