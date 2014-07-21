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

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "widgetCellId"
    var completionHandler: ((NCUpdateResult) -> Void)?
    var posts: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.preferredContentSize = CGSizeMake(0, 250.0)
        
        Post.fetch(Post.PostFilter.Top, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realDatasource = posts {
                self.posts = realDatasource
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        self.completionHandler = completionHandler
        self.completionHandler?(NCUpdateResult.NewData)
    }
    
    // Mark: TableView Management
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellId) as? UITableViewCell
        if !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: self.cellId)
        }
        
        var post = self.posts[indexPath.row] as Post
        cell!.textLabel.text = post.title
        cell!.textLabel.textColor = UIColor.whiteColor()
        
        return cell
    }
}
