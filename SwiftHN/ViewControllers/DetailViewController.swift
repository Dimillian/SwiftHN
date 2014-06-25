//
//  DetailViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 11/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    let commentCellId = "commentCellid"
    
    let hnManager = HNManager.sharedManager()
    var post: HNPost!
    
    var comments: NSArray! {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:Post"
        self.navigationController.condensesBarsOnSwipe = true
        
        self.refreshControl = UIRefreshControl()
        self.onRefreshControl()
        self.refreshControl.addTarget(self, action: "onRefreshControl", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    func onRefreshControl() {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.beginRefreshing()
        self.hnManager.loadCommentsFromPost(self.post, completion:  { (NSArray comments) in
            self.comments = comments
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        })
    }

    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        var title: NSString = self.post.Title
        return NewsCell.heightForText(title, bounds: self.tableView.bounds)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        
        if self.comments {
            return self.comments.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if (indexPath.section == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
            cell!.post = self.post
            return cell
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(commentCellId) as UITableViewCell!
        if !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: commentCellId)
        }
        
        var comment = self.comments[indexPath.row] as HNComment
        cell.textLabel.text = comment.Text
        
        return cell
    }
    
}
