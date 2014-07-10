//
//  UserViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 10/07/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared

class UserViewController: NewsViewController {

    var user: HNUser!
    
    override func viewDidLoad() {
        self.loadPost = false
    
        super.viewDidLoad()
        
        self.title = "HN:" + self.user.Username
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func onPullToFresh() {
        super.onPullToFresh()
        
        self.hnManager.fetchSubmissionsForUser(user.Username, completion: { (NSArray comments) in
            self.datasource = comments
            self.refreshing = false
        })
    }

}
