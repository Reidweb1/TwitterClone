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
	
	init() {
		
	}
	
	func convertStringToImage(url: String) -> UIImage {
		let urlFromString = NSURL(string: url)
		let newImage = UIImage(data: NSData(contentsOfURL: urlFromString))
		return newImage
	}
	
	func fetchHomeTimeline(completionHandler: (errorDescription: String?, tweets: [Tweet]?) -> Void) {
		
		let accountStore = ACAccountStore()
		let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
		accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
			if granted {
				
				let accounts = accountStore.accountsWithAccountType(accountType)
				self.twitterAccount = accounts.first as ACAccount?
				
				let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
				
				let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
				
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
	
//	func fetchTweetFavorites(tweet: Tweet) {
//		var tweetID = String((tweet.tweetInfoDictionary!["id"] as? Int)!)
//		let url = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json")
//		
//		let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: ["id": tweetID])
//		twitterRequest.account = self.twitterAccount
//		
//		twitterRequest.performRequestWithHandler { (data, httpResponse, error) -> Void in
//			switch httpResponse.statusCode {
//			case (200...299):
//				println("Good!")
//				tweet.favorites = tweet.parseToFindFavorite(data)
//			case (400...499):
//				// Use the completion handler that was passed in (usually return nil for tweets)
//				println("This is the client's fault")
//			case (500...599):
//				println("This is the server's fault")
//			default:
//				println("Something Bad Happened")
//			}
//		}
//	}
	
}