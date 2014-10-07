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
	var userName: String?
	
	init (tweetInfo : NSDictionary) {
		self.text = tweetInfo["text"] as? String
		var userDictionary = tweetInfo["user"] as NSDictionary
		self.userName = userDictionary["name"] as? String
		var imageURL = NSURL(string: (userDictionary["profile_image_url"] as? String)!)
		self.avatarImage = UIImage(data: NSData(contentsOfURL: imageURL))
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