//
//  UserSpecificTableViewController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/9/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class UserSpecificTableViewController: UITableViewController {

	var userID: String?
	var tweets: [Tweet]?
	var networkController : NetworkController!
	var avatarImage: UIImage?
	var newUserName: String?
	var userFollwers: Int?
	let numberFormatter = NSNumberFormatter()
	
	@IBOutlet weak var topBarImageView: UIImageView!
	@IBOutlet weak var topBarUserLabel: UILabel!
	@IBOutlet weak var followersTextLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
		
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.networkController = appDelegate.networkController
		
		println(self.userID!)
		
		self.networkController.fetchAllTweetsForUser(self.userID!, completionHandler: { (errorDescription, tweets) -> Void in
			if errorDescription != nil {
				println("Error in fetchAllTweetsForUser")
			} else {
				self.tweets = tweets
				NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
					self.tableView.reloadData()
				})
			}
		})
		
		self.topBarImageView.image = self.avatarImage
		self.topBarUserLabel.text = self.newUserName
		
		self.followersTextLabel.text = "Followers: " + String(userFollwers!)

		self.tableView.reloadData()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.tweets == nil {
			return 0
		} else {
			return self.tweets!.count
		}
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCellWithIdentifier("TWEET_CELL") as TweetTableViewCell
		let tweet = self.tweets?[indexPath.row]
		
		cell.userNameLabel.text = self.newUserName
		cell.tweetTextLabel.text = tweet?.text
		cell.avatarImageView.image = self.avatarImage
		
		return cell
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
