//
//  NewsViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import HackerSwifter

class NewsViewController: HNTableViewController, NewsCellDelegate, CategoriesViewControllerDelegate {
    
    var filter: Post.PostFilter = .Top
    var loadPost = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:News"
        
        self.setupNavigationItems()
    }
    
    override func onPullToFresh() {
        super.onPullToFresh()
        
        self.loadPost = true
        
        if (self.loadPost) {
            Post.fetch(self.filter, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
                if let realDatasource = posts {
                    self.datasource = realDatasource
                }
                if (!local) {
                    self.refreshing = false
                }
            })
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.onPullToFresh()
        self.showFirstTimeEditingCellAlert()
    }
    
    func setupNavigationItems() {
        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: "onRightButton")
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func onRightButton() {
        var navCategories = self.storyboard.instantiateViewControllerWithIdentifier("categoriesNavigationController") as UINavigationController
        var categoriesVC = navCategories.visibleViewController as CategoriesViewController
        categoriesVC.delegate = self
        var popController = UIPopoverController(contentViewController: navCategories)
        popController.presentPopoverFromBarButtonItem(self.navigationItem.rightBarButtonItem,
            permittedArrowDirections: UIPopoverArrowDirection.Any,
            animated: true)
        
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
    
    func showActionSheetForPost(post: Post) {
        var titles = ["Share", "Upvote", "Open", "Open in Safari", "Cancel"]
        
        var sheet = UIAlertController(title: post.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var handler = {(action: UIAlertAction?) -> () in
            self.tableView.setEditing(false, animated: true)
            if let realAction = action {
                if (action!.title == titles[0]) {
                    Helper.showShareSheet(post, controller: self)
                }
                else if (action!.title == titles[2]) {
                    var webview = self.storyboard.instantiateViewControllerWithIdentifier("WebviewController") as WebviewController
                    webview.post = post
                    self.showDetailViewController(webview, sender: nil)
                }
                else if (action!.title == titles[3]) {
                    UIApplication.sharedApplication().openURL(post.url)
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
        if self.datasource {
            return self.datasource.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        var title: NSString = (self.datasource[indexPath.row] as Post).title!
        return NewsCell.heightForText(title, bounds: self.tableView.bounds)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
        cell!.post = self.datasource[indexPath.row] as Post
        cell!.cellDelegate = self
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)  {
        if (segue.identifier == "toWebview") {
            var destination = segue.destinationViewController as WebviewController
            destination.post = self.datasource[self.tableView.indexPathsForSelectedRows()[0].row] as Post
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    override func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]!
    {
        var readingList = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "Read\nLater",
            handler: {(action: UITableViewRowAction!, indexpath: NSIndexPath!) -> Void in
                if (Helper.addPostToReadingList(self.datasource[indexPath.row] as Post)) {
           
                }
                self.tableView.setEditing(false, animated: true)
        })
        readingList.backgroundColor = UIColorEXT.ReadtListColor()
        
        var more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "More",
            handler: {(action: UITableViewRowAction!, indexpath: NSIndexPath!) -> Void in
                self.showActionSheetForPost(self.datasource[indexPath.row] as Post)
        })
        
        return [readingList, more]
    }

    // Mark: NewsCellDelegate
    func newsCellDidSelectButton(cell: NewsCell, actionType: Int, post: Post) {
        if (actionType == NewsCellActionType.Comment.toRaw()) {
            var detailVC = self.storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
            detailVC.post = post
            self.showDetailViewController(detailVC, sender: self)
        }
        else if (actionType == NewsCellActionType.Username.toRaw()) {
            if let realUsername = post.username {
                var detailVC = self.storyboard.instantiateViewControllerWithIdentifier("UserViewController") as UserViewController
                detailVC.user = realUsername
                self.showDetailViewController(detailVC, sender: self)
            }
        }
    }
    
    //Mark: CategoriesDelegate
    func categoriesViewControllerDidSelecteFilter(controller: CategoriesViewController, filer: Post.PostFilter, title: String) {
        self.filter = filer
        self.datasource = nil
        self.onPullToFresh()
        self.title = title
    }
    

}
