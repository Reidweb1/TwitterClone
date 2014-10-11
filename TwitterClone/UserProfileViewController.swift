//
//  UserProfileViewController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/10/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit
import Accounts
import Social

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var networkController: NetworkController!
	
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userFollowers: UILabel!
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var userTweetsTableView: UITableView!
	
	var tweets: [Tweet]?
	var userTweets: [Tweet]?
	var userProfilePic: UIImage?
	var userName: String?
	var userNumberOfFollowers: Int?
	var detailTweet: Tweet?
	var userID: String?
	var userInfoDictionary: NSDictionary?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.userTweetsTableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
		
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.networkController = appDelegate.networkController
		
		self.userTweetsTableView.dataSource = self
		self.userTweetsTableView.delegate = self
		
		userTweetsTableView.estimatedRowHeight = 125.0
		userTweetsTableView.rowHeight = UITableViewAutomaticDimension
		
		self.networkController.fetchHomeTimeline (completionHandler: { (errorDescription, tweets) -> Void in
			if errorDescription != nil {
				println("Error")
			} else {
				self.tweets = tweets
				self.detailTweet = self.tweets?[0]
				self.userInfoDictionary = self.detailTweet?.tweetInfoDictionary
				self.userID = self.detailTweet?.userID
				self.networkController.fetchAllTweetsForUser(self.userID!, completionHandler: { (errorDescription, tweets) -> Void in
					if errorDescription != nil {
						println("Error in fetchAllTweetsForUser")
					} else {
						self.userTweets = tweets
						NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
							self.userTweetsTableView.reloadData()
							self.userNameLabel.text = self.detailTweet?.accountName
							
						})
					}
				})
			}
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.tweets == nil {
			return 0
		} else {
			return self.tweets!.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = self.userTweetsTableView.dequeueReusableCellWithIdentifier("TWEET_CELL") as TweetTableViewCell
		let tweet = self.userTweets?[indexPath.row]
		cell.userNameLabel.text = tweet?.userName
		cell.tweetTextLabel.text = tweet?.text
		if tweet?.avatarImage != nil {
			cell.avatarImageView.image = tweet?.avatarImage
		} else {
			self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> Void in
				let cellForImage = self.userTweetsTableView.cellForRowAtIndexPath(indexPath) as TweetTableViewCell?
				cellForImage?.avatarImageView.image = image
			})
		}
		return cell
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
