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
        
        Post.fetchPost(self.user) { (posts, error, local) -> Void in
            self.ids = posts
            if (!local) {
                self.refreshing = false
            }
        }
    }
}
