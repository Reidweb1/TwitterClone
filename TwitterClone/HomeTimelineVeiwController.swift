//
//  HomeTimelineVeiwController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/6/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimelineVeiwController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	
	/*
	* Note: Cameron and I also achieved the "infinite scroll" and image cache
	* challenges on his projects.
	*/
	
	@IBOutlet weak var tableView: UITableView!
	var tweets : [Tweet]?
	var networkController : NetworkController!
	var refreshController: UIRefreshControl!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
		
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.networkController = appDelegate.networkController
		
		self.networkController.fetchHomeTimeline (completionHandler: { (errorDescription, tweets) -> Void in
			if errorDescription != nil {
				println("Error")
			} else {
				self.tweets = tweets
				NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
					self.tableView.reloadData()
				})
			}
		})
		
		self.refreshController = UIRefreshControl()
		self.refreshController.attributedTitle = NSAttributedString(string: "Pull To Refresh")
		self.refreshController.addTarget(self, action: "refreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
		self.tableView.addSubview(self.refreshController)
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		tableView.estimatedRowHeight = 125.0
		tableView.rowHeight = UITableViewAutomaticDimension		
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if self.tweets == nil {
			return 0
		} else {
			return self.tweets!.count
		}
	}
	
	func refreshTableView(sender: AnyObject!) {
		self.networkController.fetchHomeTimeline(sinceID: self.tweets!.first!.sinceID) { (errorDescription, tweets) -> Void in
			
			for tweet in tweets! {
				
				self.tweets?.insert(tweet, atIndex: 0)
				println(tweet.sinceID)
			}
			NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
				self.tableView.reloadData()
				self.refreshController.endRefreshing()
			})
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetTableViewCell
		let tweet = self.tweets?[indexPath.row]
		cell.userNameLabel.text = tweet?.userName
		cell.tweetTextLabel.text = tweet?.text
		if tweet?.avatarImage != nil {
			cell.avatarImageView.image = tweet?.avatarImage
		} else {
			self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> Void in
				let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetTableViewCell?
				cellForImage?.avatarImageView.image = image
			})
		}
		return cell
	}
	
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		let tweet = self.tweets?[indexPath.row]
		
		let newDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_TWEET_VIEW") as TwitterDetailViewController
		newDetailViewController.detailTweet = tweet
		self.navigationController?.pushViewController(newDetailViewController, animated: true)
		
	}
}
