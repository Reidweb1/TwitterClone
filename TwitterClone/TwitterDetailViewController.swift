//
//  TwitterDetailViewController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/8/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class TwitterDetailViewController: UIViewController, UIGestureRecognizerDelegate {

	var detailTweet: Tweet!
	
	@IBOutlet weak var detailImageVew: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var retweetLabel: UILabel!
	@IBOutlet weak var favoritesLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//self.networkController.fetchTweetFavorites(selectedTweet!)
		
		self.detailImageVew.image = detailTweet.avatarImage
		self.userNameLabel.text = detailTweet.userName
		self.tweetTextLabel.text = detailTweet.text
		self.retweetLabel.text = detailTweet.retweets! + " Retweets"
		self.favoritesLabel.text = detailTweet.favorites! + " Favorites"
		
		var UIGestureForImage = UITapGestureRecognizer(target: self, action: "tappedImage:")
		UIGestureForImage.delegate = self
		self.detailImageVew.addGestureRecognizer(UIGestureForImage)
		
		var UIGestureForLabel = UITapGestureRecognizer(target: self, action: "tappedUserName:")
		UIGestureForLabel.delegate = self
		self.userNameLabel.addGestureRecognizer(UIGestureForLabel)
		
		self.userNameLabel.userInteractionEnabled = true
		self.detailImageVew.userInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tappedImage(sender: AnyObject) {
		let newUserViewController = self.storyboard?.instantiateViewControllerWithIdentifier("USER_TABLE_VIEW_CONTROLLER") as UserSpecificTableViewController
		newUserViewController.userID = self.detailTweet.userID
		newUserViewController.avatarImage = self.detailTweet.avatarImage
		newUserViewController.newUserName = self.detailTweet.userName
		newUserViewController.userFollwers = self.detailTweet.followers
		self.navigationController?.pushViewController(newUserViewController, animated: true)
		
	}
	func tappedUserName(sender: AnyObject) {
		let newUserViewController = self.storyboard?.instantiateViewControllerWithIdentifier("USER_TABLE_VIEW_CONTROLLER") as UserSpecificTableViewController
		newUserViewController.userID = self.detailTweet.userID
		newUserViewController.avatarImage = self.detailTweet.avatarImage
		newUserViewController.newUserName = self.detailTweet.userName
		newUserViewController.userFollwers = self.detailTweet.followers
		self.navigationController?.pushViewController(newUserViewController, animated: true)
	}
}
