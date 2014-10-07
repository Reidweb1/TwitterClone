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
	var twitterAccount: ACAccount?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		// Don't need downcasting since pathForResource returns String?
		
//		if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//			var error : NSError?
//			let jsonData = NSData(contentsOfFile: path)
//			
//			self.tweets = Tweet.parseJOSNDataIntoTweets(jsonData)
//			
//			self.tweets = self.tweets?.sorted({ (tweet1: Tweet, tweet2: Tweet) -> Bool in
//				return tweet1.text < tweet2.text
//			})
//		}
		
		let accountStore = ACAccountStore()
		let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
		accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
			if granted {
				// Below passes back an array of all of the accounts of the type passed in (Twitter)
				// The closure is capturing a reference to the local variable accountType since it's working off the main thread
				
				let accounts = accountStore.accountsWithAccountType(accountType)
				self.twitterAccount = accounts.first as ACAccount?
				
				// Needs casting since the return value is [AnyObject]
				
				let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
				
				// SLRequestMethod is an enum that is accessed with dot notation
				
				let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
				
				// Sets the request's account property to the account we recieved
				
				twitterRequest.account = self.twitterAccount
				
				twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
					
					// Network people will know which error's your server will be looking for
					
					switch httpResponse.statusCode {
					case (200...299):
						self.tweets = Tweet.parseJOSNDataIntoTweets(data)
						// this is done on a background thread/ queue automatically thru the social framwork
						
						// we need to get reload data back on the main thread since it's an interface operation
						NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
							self.tableView.reloadData()
						})
					case (400...499):
						println("This is the client's fault")
					case (500...599):
						println("This is the server's fault")
					default:
						println("Something Bad Happened")
					}
				})
			}
		}
		
	}

	func viewDidAppear() {
		self.tweets = self.tweets?.sorted({ (tweet1: Tweet, tweet2: Tweet) -> Bool in
			return tweet1.text < tweet2.text
		})
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
		cell.tweetAvatoarImage.image = tweet?.avatarImage
		cell.tweetUserNameLabel.text = tweet?.userName
		cell.tweetTextView.text = tweet?.text
		return cell
	}
	
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		println("Selected \(indexPath.row)")
	}
}
