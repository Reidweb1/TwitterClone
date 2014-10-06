//
//  HomeTimelineVeiwController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/6/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class HomeTimelineVeiwController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	var tweets : [Tweet]?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		// Don't need downcasting since pathForResource returns String?
		
		if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
			var error : NSError?
			let jsonData = NSData(contentsOfFile: path)
			
			self.tweets = Tweet.parseJOSNDataIntoTweets(jsonData!)
			
		}
		
        // Do any additional setup after loading the view.
    }

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if self.tweets == nil {
			println("Tweets Returned nil")
			return 1
		} else {
			return self.tweets!.count
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
		let tweet = self.tweets?[indexPath.row]
		cell.textLabel?.text = tweet?.text
		return cell
	}
	
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		println("Selected \(indexPath.row)")
	}
	
}
