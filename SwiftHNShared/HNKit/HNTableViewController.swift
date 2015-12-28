//
//  HNTableViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 26/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import HackerSwifter

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
    
    public var cellHeight: [CGFloat] = []
    public var cachedItems: [Item] = []
        
    public var ids: [Int] = [] {
        didSet {
            self.cellHeight = [CGFloat](count: self.ids.count, repeatedValue: self.defaultCellHeight())
            self.cachedItems = [Item](count: self.ids.count, repeatedValue: Item(id: -1))
            self.tableView.reloadData()
        }
    }
    
    public func defaultCellHeight() -> CGFloat {
        return 100.0
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
    }
}
