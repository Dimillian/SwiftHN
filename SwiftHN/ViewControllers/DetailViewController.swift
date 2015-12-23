//
//  DetailViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 11/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import HackerSwifter

class DetailViewController: HNTableViewController, NewsCellDelegate {
    
    var post: Post!
    var cellHeightCache: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:Post"
        
        self.setupBarButtonItems()
        self.onPullToFresh()
    }
    
    func onPullToFresh() {
        
        Comment.fetch(forPost: self.post, completion: {(comments: [Comment]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realDatasource = comments {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, UInt(0)), { ()->() in
                    self.cacheHeight(realDatasource)
                    dispatch_async(dispatch_get_main_queue(), { ()->() in
                        self.datasource = realDatasource
                        })
                    })
            }
            if (!local) {
                self.refreshing = false
            }
        })
    }
    
    func cacheHeight(comments: NSArray) {
        cellHeightCache = []
        for comment : AnyObject in comments {
            if let realComment = comment as? Comment {
                let height = CommentsCell.heightForText(realComment.text!, bounds: self.tableView.bounds, level: realComment.depth)
                cellHeightCache.append(height)
            }
        }
    }
    
    
    func setupBarButtonItems() {
        let shareItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onShareButton")
        self.navigationItem.rightBarButtonItem = shareItem
    }
    
    func onShareButton() {
        Helper.showShareSheet(self.post, controller: self, barbutton: self.navigationItem.rightBarButtonItem)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.section == 0) {
            let title: NSString = self.post.title!
            return NewsCell.heightForText(title, bounds: self.tableView.bounds)
        }
        return self.cellHeightCache[indexPath.row] as CGFloat
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        
        if (self.datasource != nil) {
            return self.datasource.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
            cell!.post = self.post
            cell!.cellDelegate = self;
            return cell!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CommentsCellId) as! CommentsCell!
        let comment = self.datasource[indexPath.row] as! Comment
        cell.comment = comment
        
        return cell
    }
    
    //MARK: NewsCellDelegate
    func newsCellDidSelectButton(cell: NewsCell, actionType: Int, post: Post) {   
        if (actionType == NewsCellActionType.Username.rawValue) {
            if let realUsername = post.username {
                let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as! UserViewController
                detailVC.user = realUsername
                self.showDetailViewController(detailVC, sender: self)
            }
        }
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
            destination.post = self.post
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                //Nothing to do here, I just want to be noticed when the transition is done. 
                //It's actuallu quite nice to have the final size of size of the current layout,
                //Event if it's useless in our case.
            }, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, UInt(0)), { ()->() in
                    self.cacheHeight(self.datasource)
                    dispatch_async(dispatch_get_main_queue(), { ()->() in
                        self.tableView.reloadData()
                    })
                })
        })
    }
    
}
