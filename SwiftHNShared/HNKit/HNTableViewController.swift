//
//  HNTableViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 26/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

public class HNTableViewController: UITableViewController {

    public var refreshing: Bool = false {
    didSet {
        if (self.refreshing) {
            self.refreshControl?.beginRefreshing()
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Loading...")
        }
        else {
            self.refreshControl?.endRefreshing()
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        }
    }
    }
    
    public var datasource: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public var ids: [Int]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
    }
}
