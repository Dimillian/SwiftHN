//
//  DetailViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 11/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared

class DetailViewController: HNTableViewController {

    let commentCellId = "commentCellid"
    
    let hnManager = HNManager.sharedManager()
    var post: HNPost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:Post"
        
        self.setupBarButtonItems()
        self.onPullToFresh()
    }
    
    override func onPullToFresh() {
        super.onPullToFresh()
        
        self.hnManager.loadCommentsFromPost(self.post, completion:  { (NSArray comments) in
            self.datasource = comments
            self.refreshing = false
        })
    }
    
    
    func setupBarButtonItems() {
        var shareItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onShareButton")
        self.navigationItem.rightBarButtonItem = shareItem
    }
    
    func onShareButton() {
        
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
        
        if self.datasource {
            return self.datasource.count
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
        
        var comment = self.datasource[indexPath.row] as HNComment
        cell.textLabel.text = comment.Text
        
        return cell
    }
    
}
