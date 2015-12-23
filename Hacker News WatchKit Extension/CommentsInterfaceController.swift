//
//  CommentsInterfaceController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 10/03/15.
//  Copyright (c) 2015 Thomas Ricouard. All rights reserved.
//

import WatchKit
import Foundation
import HackerSwifterWatch

class HNCommentRow: NSObject {
    @IBOutlet var commentLabel: WKInterfaceLabel!
    @IBOutlet var usernameLabel: WKInterfaceLabel!
}

class CommentsInterfaceController: WKInterfaceController {
    var post: Post!
    var datasource: [Comment]!
    
    @IBOutlet var tableView: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        if let realPost = context as? Post {
            self.post = realPost
            
            Comment.fetch(forPost: self.post, completion: {(comments: [Comment]!, error: Fetcher.ResponseError!, local: Bool) in
                self.datasource = comments
                self.setupTable()
            })
        }
    }
    
    func setupTable() {
        self.tableView.setNumberOfRows(self.datasource.count, withRowType: "HNCommentRow")
        var rowCount = 0
        for item in self.datasource {
            let row = self.tableView.rowControllerAtIndex(rowCount) as! HNCommentRow
            if let realtext = item.text {
                row.commentLabel.setText(realtext)
                row.usernameLabel.setText(item.username)
            }
            rowCount++
        }
    }
}
