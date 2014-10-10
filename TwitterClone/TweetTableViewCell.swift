//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/7/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
	
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
