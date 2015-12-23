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
    var loadMoreEnabled = false
    var infiniteScrollingView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:News"
        
        self.setupInfiniteScrollingView()
        self.setupNavigationItems()
    }
    
    private func setupInfiniteScrollingView() {
        self.infiniteScrollingView = UIView(frame: CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60))
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.LoadMoreLightGrayColor()
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityViewIndicator.color = UIColor.darkGrayColor()
        activityViewIndicator.frame = CGRectMake(self.infiniteScrollingView!.frame.size.width/2-activityViewIndicator.frame.width/2, self.infiniteScrollingView!.frame.size.height/2-activityViewIndicator.frame.height/2, activityViewIndicator.frame.width, activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.infiniteScrollingView!.addSubview(activityViewIndicator)
    }
    
    func onPullToFresh() {
        
        self.refreshing = true
        
        Post.fetch(self.filter, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realDatasource = posts {
                self.datasource = realDatasource
                if (self.datasource.count % 30 == 0) {
                    self.loadMoreEnabled = true
                } else {
                    self.loadMoreEnabled = false
                }
            }
            if (!local) {
                self.refreshing = false
            }
        })
    }
    
    func loadMore() {
        let fetchPage = Int(ceil(Double(self.datasource.count)/30))+1
        Post.fetch(self.filter, page:fetchPage, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realDatasource = posts {
                let tempDatasource:NSMutableArray = NSMutableArray(array: self.datasource)
                let postsNotFromNewPageCount = ((fetchPage-1)*30)
                if (tempDatasource.count - postsNotFromNewPageCount > 0) {
                    tempDatasource.removeObjectsInRange(NSMakeRange(postsNotFromNewPageCount, tempDatasource.count-postsNotFromNewPageCount))
                }
                tempDatasource.addObjectsFromArray(realDatasource)
                self.datasource = tempDatasource
                if (self.datasource.count % 30 == 0) {
                    self.loadMoreEnabled = true
                } else {
                    self.loadMoreEnabled = false
                }
            }
            if (!local) {
                self.refreshing = false
                self.tableView.tableFooterView = nil
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.onPullToFresh()
        self.showFirstTimeEditingCellAlert()
    }
    
    func setupNavigationItems() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: "onRightButton")
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func onRightButton() {
        let navCategories = self.storyboard?.instantiateViewControllerWithIdentifier("categoriesNavigationController") as! UINavigationController
        let categoriesVC = navCategories.visibleViewController as! CategoriesViewController
        categoriesVC.delegate = self
        navCategories.modalPresentationStyle = UIModalPresentationStyle.Popover
        if (navCategories.popoverPresentationController != nil) {
            navCategories.popoverPresentationController?.sourceView = self.view
            navCategories.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        self.presentViewController(navCategories, animated: true, completion: nil)
        
    }
    
    //MARK: Alert management
    func showFirstTimeEditingCellAlert() {
        if (!Preferences.sharedInstance.firstTimeLaunch) {
            let alert = UIAlertController(title: "Quick actions",
                message: "By swiping a cell you can quickly send post to the Safari Reading list, or use the more button to share it and access other functionalities",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: {(action: UIAlertAction) in
                Preferences.sharedInstance.firstTimeLaunch = true
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showActionSheetForPost(post: Post) {
        var titles = ["Share", "Open", "Open in Safari", "Cancel"]
        
        let sheet = UIAlertController(title: post.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let handler = {(action: UIAlertAction?) -> () in
            self.tableView.setEditing(false, animated: true)
            if let _ = action {
                if (action!.title == titles[0]) {
                    Helper.showShareSheet(post, controller: self, barbutton: nil)
                }
                else if (action!.title == titles[1]) {
                    let webview = self.storyboard?.instantiateViewControllerWithIdentifier("WebviewController") as! WebviewController
                    webview.post = post
                    self.showDetailViewController(webview, sender: nil)
                }
                else if (action!.title == titles[2]) {
                    UIApplication.sharedApplication().openURL(post.url!)
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
    
    //MARK: TableView Management
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    override func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        if (self.datasource != nil) {
            return self.datasource.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let title: NSString = (self.datasource[indexPath.row] as! Post).title!
        return NewsCell.heightForText(title, bounds: self.tableView.bounds)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
        cell!.post = self.datasource[indexPath.row] as! Post
        cell!.cellDelegate = self
        if (loadMoreEnabled && indexPath.row == self.datasource.count-3) {
            self.tableView.tableFooterView = self.infiniteScrollingView
            loadMore()
        }
        return cell!
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if #available(iOS 9, *) {
            if identifier == "toWebview" {
                if let url = (sender as? NewsCell)?.post.url {
                    presentViewController(SafariViewController(URL: url), animated: true, completion: nil)
                    return false
                }
            }
        }
        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if (segue.identifier == "toWebview") {
            let destination = segue.destinationViewController as! WebviewController
            if let selectedRows = self.tableView.indexPathsForSelectedRows {
                destination.post = self.datasource[selectedRows[0].row] as? Post
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]
    {
        let readingList = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "Read\nLater",
            handler: {(action: UITableViewRowAction, indexpath: NSIndexPath) -> Void in
                if (Helper.addPostToReadingList(self.datasource[indexPath.row] as! Post)) {
                }
                _ = self.datasource
                Preferences.sharedInstance.addToReadLater(self.datasource[indexPath.row] as! Post)
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! NewsCell
                cell.readLaterIndicator.hidden = false
                self.tableView.setEditing(false, animated: true)
        })
        readingList.backgroundColor = UIColor.ReadingListColor()
        
        let more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "More",
            handler: {(action: UITableViewRowAction, indexpath: NSIndexPath) -> Void in
                self.showActionSheetForPost(self.datasource[indexPath.row] as! Post)
        })
        
        return [readingList, more]
    }
    
    //MARK: NewsCellDelegate
    func newsCellDidSelectButton(cell: NewsCell, actionType: Int, post: Post) {
        
        let indexPath = self.tableView.indexPathForCell(cell)
        if let realIndexPath = indexPath {
            let delay = 0.2 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                self.tableView.selectRowAtIndexPath(realIndexPath, animated: false, scrollPosition: .None)
            }
        }
        if (actionType == NewsCellActionType.Comment.rawValue) {
            let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            detailVC.post = post
            self.showDetailViewController(detailVC, sender: self)
        }
        else if (actionType == NewsCellActionType.Username.rawValue) {
            if let realUsername = post.username {
                let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as! UserViewController
                detailVC.user = realUsername
                self.showDetailViewController(detailVC, sender: self)
            }
        }
    }
    
    //MARK: CategoriesDelegate
    func categoriesViewControllerDidSelecteFilter(controller: CategoriesViewController, filer: Post.PostFilter, title: String) {
        self.filter = filer
        self.datasource = nil
        self.onPullToFresh()
        self.title = title
    }
    
    func delayedSelection(indexpath: NSIndexPath) {

    }
    
    
}
