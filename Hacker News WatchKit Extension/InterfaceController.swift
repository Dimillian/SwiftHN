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
    var datasource: [Post]!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        Post.fetch(Post.PostFilter.Top, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            self.datasource = posts
            self.setupTable();
        })

    }
    
    func setupTable() {
        self.tableView.setNumberOfRows(self.datasource.count, withRowType: "HNNewsRow")
        var rowCount = 0
        for item in self.datasource {
            let row = self.tableView.rowControllerAtIndex(rowCount) as! HNNewsRow
            row.voteLabel.setText(String(item.points))
            row.titleLabel.setText(item.title)
            row.usernameLabel.setText(String(item.commentsCount) + " Comments")
            row.domainLabel.setText(item.domain)
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
