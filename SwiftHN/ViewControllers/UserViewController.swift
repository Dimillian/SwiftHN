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
        
        Post.fetch(self.user, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realPosts = posts {
                self.datasource = realPosts
                if (self.datasource.count % 30 == 0) {
                    self.loadMoreEnabled = true
                } else {
                    self.loadMoreEnabled = false
                }
            }
            if (!local) {
                self.refreshing = false   
            }
        })
    }
    override func loadMore() {
        let fetchPage = Int(ceil(Double(self.datasource.count)/30))+1
        Post.fetch(self.user, page:fetchPage, lastPostId:(self.datasource.lastObject as! Post).postId, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realPosts = posts {
                let tempPosts:NSMutableArray = NSMutableArray(array: self.datasource)
                let postsNotFromNewPageCount = ((fetchPage-1)*30)
                if (postsNotFromNewPageCount > 0) {
                    tempPosts.removeObjectsInRange(NSMakeRange(postsNotFromNewPageCount, tempPosts.count-postsNotFromNewPageCount))
                }
                tempPosts.addObjectsFromArray(realPosts)
                self.datasource = tempPosts
                if (self.datasource.count % 30 == 0) {
                    self.loadMoreEnabled = true
                } else {
                    self.loadMoreEnabled = false
                }
            }
            if (!local) {
                self.refreshing = false
                self.tableView.tableFooterView = nil
            }
        })
    }

}
