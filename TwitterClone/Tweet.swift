//
//  Tweet.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/6/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
	
	// Properties need a default value, marked as an optional, or in an initializer
	
	var text: String?
	var avatarImage: UIImage?
	var avatarURL: String?
	var userName: String?
	var retweets: String?
	var favorites: String?
	var userID: String?
	var tweetInfoDictionary: NSDictionary?
	var followers: Int?
	
	init (tweetInfo : NSDictionary) {
		self.tweetInfoDictionary = tweetInfo
		
		self.text = tweetInfo["text"] as? String
		let userDictionary = tweetInfo["user"] as NSDictionary
		self.userName = userDictionary["name"] as? String
		self.avatarURL = userDictionary["profile_image_url"] as? String
		self.userID = userDictionary["id_str"] as? String
		var retweetInt = tweetInfo["retweet_count"] as? Int
		var favoriteint = tweetInfo["favorite_count"] as? Int
		self.retweets = String(retweetInt!)
		self.favorites = String(favoriteint!)
		self.followers = userDictionary["followers_count"] as? Int
	}
	
	// Factory method will produce the class
	
	class func parseJOSNDataIntoTweets(rawJSONData: NSData ) -> [Tweet]? {
		
		var error: NSError?
		if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
			
			var tweets = [Tweet]()
			
			for JSONDictionary in JSONArray {
				if let tweetDictionary = JSONDictionary as? NSDictionary {
					var newTweet = Tweet(tweetInfo: tweetDictionary)
					
					tweets.append(newTweet)
				}
			}
			return tweets
		}
		return nil
	}
}