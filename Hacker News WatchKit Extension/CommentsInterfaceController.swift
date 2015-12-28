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
    var post: Item!
    var datasource: [Int]!
    
    @IBOutlet var tableView: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        if let realPost = context as? Item {
            self.post = realPost
            setupTable()
        }
    }
    
    func setupTable() {
        self.tableView.setNumberOfRows(self.datasource.count, withRowType: "HNCommentRow")
        var rowCount = 0
        for item in self.datasource {
            let row = self.tableView.rowControllerAtIndex(rowCount) as! HNCommentRow
            setupRow(row, id: item)
            rowCount++
        }
    }
    
    func setupRow(row: HNCommentRow, id: Int) {
        Item.fetchPost(id, completion: { (item, error, local) -> Void in
            row.commentLabel.setText(item.text!)
            row.usernameLabel.setText(item.username!)
        })
    }
}
