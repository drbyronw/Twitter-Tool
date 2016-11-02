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
    var tagline: String?
    
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
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
    }
    
}
