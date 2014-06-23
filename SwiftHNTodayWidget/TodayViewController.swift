//
//  TodayViewController.swift
//  SwiftHNTodayWidget
//
//  Created by Thomas Ricouard on 18/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellId = "widgetCellId"
    let hnManager = HNManager.sharedManager()
    var posts: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    @IBOutlet var tableView: UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.preferredContentSize = CGSizeMake(0, 250.0)
        self.view.addSubview(self.tableView)
        
        print("Hello world")
        self.hnManager.loadPostsWithFilter(.Top, completion: { (NSArray posts) in
            self.posts = posts
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
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
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.cellId)
        }
        
        var post = self.posts[indexPath.row] as HNPost
        cell!.textLabel.text = post.Title
        cell!.detailTextLabel.text = post.UrlString
        
        return cell
    }
}
