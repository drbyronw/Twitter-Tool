//
//  TweetCell.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 11/2/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit
import AFNetworking
import NSDateMinimalTimeAgo

protocol TweetCellDelegate {
    func viewProfile(_ sender: TweetCell)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var delegate: TweetCellDelegate?
    
    var tap = UITapGestureRecognizer()
  
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = tweet.user?.screenName
            profileImageView.setImageWith((tweet.user?.profileUrl)!)
            timeLabel.text = tweet.timeStamp?.timeAgo()
        }
    }
    
    func profileImageTapped() {
        delegate?.viewProfile(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retweetedLabel.isEnabled = false
        retweetedImageView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TweetCell.profileImageTapped))
        tap.numberOfTapsRequired = 1
//        tap.addTarget(self, action: #selector(TweetCell.profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
