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
        self.loadPost = false
    
        super.viewDidLoad()
        
        self.title = "HN:" + user
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func onPullToFresh() {
        super.onPullToFresh()
        
        Post.fetch(self.user, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realPosts = posts {
                self.datasource = realPosts
            }
            if (!local) {
                self.refreshing = false   
            }
        })
    }

}
