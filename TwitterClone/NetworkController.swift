//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/8/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
	
	var twitterAccount : ACAccount?
	
	// NSOperationQueue creates an arbitrary background queue
	let imageQueue = NSOperationQueue()
	
	init() {
		self.imageQueue.maxConcurrentOperationCount = 6
		// self.imageQueue.cancelAllOperations()
	}
	
	func convertStringToImage(url: String) -> UIImage {
		let urlFromString = NSURL(string: url)
		let newImage = UIImage(data: NSData(contentsOfURL: urlFromString))
		return newImage
	}
	
	func downloadUserImageForTweet (tweet: Tweet, completionHandler : (image: UIImage) -> Void) {
		
		self.imageQueue.addOperationWithBlock { () -> Void in
			let url = NSURL(string: tweet.avatarURL!)
			let imageData = NSData(contentsOfURL: url)
			let avatarImage = UIImage(data: imageData)
			tweet.avatarImage = avatarImage
			NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
				completionHandler(image: avatarImage)
			})
		}
	}
	
	func fetchHomeTimeline(sinceID: String = "", completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> Void) {
		
		let accountStore = ACAccountStore()
		let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
		accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
			if granted {
				
				let accounts = accountStore.accountsWithAccountType(accountType)
				self.twitterAccount = accounts.first as ACAccount?
				
				let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
				
				var twitterRequest: SLRequest!
				
				if sinceID != "" {
					twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: ["since_id":sinceID])
				} else {
					twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
				}
				
				twitterRequest.account = self.twitterAccount
				
				twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
					
					// Network people will know which error's your server will be looking for
					
					switch httpResponse.statusCode {
					case (200...299):
						 let tweets = Tweet.parseJOSNDataIntoTweets(data)
						 completionHandler(errorDescription: nil, tweets: tweets)
					case (400...499):
						// Use the completion handler that was passed in (usually return nil for tweets)
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
	
	
	func fetchAllTweetsForUser(userID: String, completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> Void) {
		
		let url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userID)")
		let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
		twitterRequest.account = self.twitterAccount
		twitterRequest.performRequestWithHandler { (data, httpResponse, error) -> Void in
			
			switch httpResponse.statusCode {
			case (200...299):
				let tweets = Tweet.parseJOSNDataIntoTweets(data)
				completionHandler(errorDescription: nil, tweets: tweets)
				println("Good!")
			case (400...499):
				println("This is the client's fault")
			case (500...599):
				println("This is the server's fault")
			default:
				println("Something Bad Happened")
			}
			
		}
	}
}