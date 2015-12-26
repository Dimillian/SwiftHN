//
//  InterfaceController.swift
//  Hacker News WatchKit Extension
//
//  Created by Thomas Ricouard on 10/03/15.
//  Copyright (c) 2015 Thomas Ricouard. All rights reserved.
//

import WatchKit
import Foundation
import HackerSwifterWatch

class HNNewsRow: NSObject {
    @IBOutlet var voteLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var usernameLabel: WKInterfaceLabel!
    @IBOutlet var domainLabel: WKInterfaceLabel!
}

class InterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    var datasource: [Int]!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        Post.fetchPost(.Top) { (posts, error, local) -> Void in
            self.datasource = posts
            self.setupTable();
        }
    }
    
    func setupTable() {
        self.tableView.setNumberOfRows(self.datasource.count, withRowType: "HNNewsRow")
        var rowCount = 0
        for item in self.datasource {
            let row = self.tableView.rowControllerAtIndex(rowCount) as! HNNewsRow
            Post.fetchPost(item, completion: { (post, error, local) -> Void in
                row.voteLabel.setText(String(post.score))
                row.titleLabel.setText(post.title!)
                row.usernameLabel.setText(String(post.commentsCount) + " Comments")
                row.domainLabel.setText(post.domain!)
            })
            rowCount++
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let post = self.datasource[rowIndex]
        presentControllerWithName("commentsController", context: post)
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
