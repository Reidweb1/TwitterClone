//
//  TwitterDetailViewController.swift
//  TwitterClone
//
//  Created by Reid Weber on 10/8/14.
//  Copyright (c) 2014 com.reidweber. All rights reserved.
//

import UIKit

class TwitterDetailViewController: UIViewController {

	var detailTweet: Tweet!
	
	@IBOutlet weak var detailImageVew: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var retweetLabel: UILabel!
	@IBOutlet weak var favoritesLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//self.networkController.fetchTweetFavorites(selectedTweet!)
		
		self.detailImageVew.image = detailTweet.avatarImage
		self.userNameLabel.text = detailTweet.userName
		self.tweetTextLabel.text = detailTweet.text
		self.retweetLabel.text = detailTweet.retweets! + " Retweets"
		self.favoritesLabel.text = detailTweet.favorites! + " Favorites"
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
