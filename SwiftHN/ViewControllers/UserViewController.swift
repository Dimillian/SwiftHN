//
//  UserViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 10/07/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import HackerSwifter

class UserViewController: NewsViewController {

    var user: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:" + user
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func onPullToFresh() {
        
        self.refreshing = true
        
        Item.fetchPost(self.user) { (items, error, local) -> Void in
            self.ids = items
            if (!local) {
                self.refreshing = false
            }
        }
    }
}
