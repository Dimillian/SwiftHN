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

class DetailViewController: HNTableViewController {
    
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
                var height = CommentsCell.heightForText(realComment.text!, bounds: self.tableView.bounds, level: realComment.depth)
                cellHeightCache.append(height)
            }
        }
    }
    
    
    func setupBarButtonItems() {
        var shareItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onShareButton")
        self.navigationItem.rightBarButtonItem = shareItem
    }
    
    func onShareButton() {
        Helper.showShareSheet(self.post, controller: self, barbutton: self.navigationItem.rightBarButtonItem)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.section == 0) {
            var title: NSString = self.post.title!
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
            var cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
            cell!.post = self.post
            return cell!
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CommentsCellId) as CommentsCell!
        var comment = self.datasource[indexPath.row] as Comment
        cell.comment = comment
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if (segue.identifier == "toWebview") {
            var destination = segue.destinationViewController as WebviewController
            destination.post = self.post
        }
    }
    
}
