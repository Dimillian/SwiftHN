//
//  NewsViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared

class NewsViewController: UITableViewController, NewsCellDelegate {
    
    let hnManager = HNManager.sharedManager()
    var posts: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:News"
        self.navigationController.condensesBarsOnSwipe = true
        
        self.refreshControl = UIRefreshControl()
        
        self.onRefreshControl()
        
        self.refreshControl.addTarget(self, action: "onRefreshControl", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func onRefreshControl() {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.beginRefreshing()
        self.hnManager.loadPostsWithFilter(.Top, completion: { (NSArray posts) in
            self.posts = posts
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showFirstTimeEditingCellAlert()
    }
    
    // Mark: Alert management
    func showFirstTimeEditingCellAlert() {
        if (!Preferences.sharedInstance.firstTimeLaunch) {
            var alert = UIAlertController(title: "Post quick actions",
                message: "By swipping a cell you can quickly send post to the Safari reding list, or use the more button to share it and access other functionalities",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: {(action: UIAlertAction?) in
                Preferences.sharedInstance.firstTimeLaunch = true
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showActionSheetForPost(post: HNPost) {
        var titles = ["Share", "Add to Reading List", "Upvote", "Cancel"]
        
        var sheet = UIAlertController(title: post.Title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var handler = {(action: UIAlertAction?) -> () in
            self.tableView.setEditing(false, animated: true)
            if let realAction = action {
                if (action!.title == titles[0]) {
                    
                }
                else if (action!.title == titles[1]) {
                    Helper.addPostToReadingList(post)
                }
                else if (action!.title == titles[2]) {
                    
                }
            }
        }
        
        for title in titles {
            var type = UIAlertActionStyle.Default
            if (title == "Cancel") {
                type = UIAlertActionStyle.Cancel
            }
            sheet.addAction(UIAlertAction(title: title, style: type, handler: handler))
        }
        
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    // Mark: TableView Management
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        return 1
    }
    
    override func tableView(tableView: UITableView!,numberOfRowsInSection section: Int) -> Int {
        if self.posts {
            return self.posts.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        var title: NSString = (self.posts[indexPath.row] as HNPost).Title
        return NewsCell.heightForText(title, bounds: self.tableView.bounds)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
        cell!.post = self.posts[indexPath.row] as HNPost
        cell!.cellDelegate = self
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)  {
        if (segue.identifier == "toWebview") {
            var destination = segue.destinationViewController as WebviewController
            destination.post = self.posts[self.tableView.indexPathsForSelectedRows()[0].row] as HNPost
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    override func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> AnyObject[]!
    {
        var readingList = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "Read\nLater",
            handler: {(action: UITableViewRowAction!, indexpath: NSIndexPath!) -> Void in
                if (Helper.addPostToReadingList(self.posts[indexPath.row] as HNPost)) {
           
                }
                self.tableView.setEditing(false, animated: true)
        })
        readingList.backgroundColor = UIColorEXT.ReadtListColor()
        
        var more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "More",
            handler: {(action: UITableViewRowAction!, indexpath: NSIndexPath!) -> Void in
                self.showActionSheetForPost(self.posts[indexPath.row] as HNPost)
        })
        
        return [readingList, more]
    }

    // Mark: NewsCellDelegate
    func newsCellDidSelectButton(cell: NewsCell,  actionType: NewsCellActionType) {
        var detailVC = self.storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        self.showDetailViewController(detailVC, sender: self)
    }
    

}
