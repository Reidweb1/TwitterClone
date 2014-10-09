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

	@IBOutlet weak var tableView: UITableView!
	var tweets : [Tweet]?
	var networkController : NetworkController!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.networkController = appDelegate.networkController
		
		self.networkController.fetchHomeTimeline { (errorDescription, tweets) -> Void in
			if errorDescription != nil {
				println("Error")
			} else {
				self.tweets = tweets
				NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
					self.tableView.reloadData()
				})
			}
		}
		
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

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetTableViewCell
		let tweet = self.tweets?[indexPath.row]
		cell.tweetUserNameLabel.text = tweet?.userName
		cell.tweetTextLabel.text = tweet?.text
		cell.tweetAvatoarImage.image = tweet?.avatarImage
		return cell
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "tweetDetail" {
			let destinationViewController = segue.destinationViewController as TwitterDetailViewController
			let indexPath = self.tableView.indexPathForSelectedRow()
			let selectedTweet = self.tweets?[indexPath!.row]
			destinationViewController.detailTweet = selectedTweet
		}
	}
	
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		
	}
}
