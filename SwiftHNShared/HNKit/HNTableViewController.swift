//
//  HNTableViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 26/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

class HNTableViewController: UITableViewController {

    var refreshing: Bool = false {
    didSet {
        if (self.refreshing) {
            self.refreshControl.beginRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        }
        else {
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        }
    }
    }
    
    var datasource: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func onPullToFresh() {
        self.refreshing = true
    }
    
}
