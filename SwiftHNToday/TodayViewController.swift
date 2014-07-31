//
//  TodayViewController.swift
//  SwiftHNTodayWidget
//
//  Created by Thomas Ricouard on 18/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import NotificationCenter
import HackerSwifter
import SwiftHNShared


class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "widgetCellId"
    let topBottomWidgetInset: CGFloat = 10.0
    
    var completionHandler: ((NCUpdateResult) -> Void)?
    var posts: [Post] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var expanded: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.preferredContentSize = CGSizeMake(0, 300.0)
    
        Post.fetch(Post.PostFilter.Top, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realDatasource = posts {
                self.posts = realDatasource
                self.completionHandler?(NCUpdateResult.NewData)
            }
        })
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.topBottomWidgetInset, 0, self.topBottomWidgetInset, 0)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        self.completionHandler = completionHandler
        self.completionHandler?(NCUpdateResult.NewData)
    }
    
    //MARK: Actions
    
    func onViewMoreButton() {
        self.expanded = true
    }
    
    //MARK: TableView Management
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        return 1
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if self.expanded {
            return self.posts.count
        }
        return self.posts.count > 5 ? 5 : self.posts.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 55.0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(todayCellId) as? TodayWidgetCell
        var post = self.posts[indexPath.row] as Post
        cell!.post = post
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var post = self.posts[indexPath.row] as Post
        self.extensionContext.openURL(post.url, completionHandler: nil)
    }
}
