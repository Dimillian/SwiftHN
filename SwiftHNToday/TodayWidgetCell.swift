//
//  TodayWidgetCell.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 31/07/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import HackerSwifter
import SwiftHNShared

let todayCellId = "todayCell"

class TodayWidgetCell: UITableViewCell {
    
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var postSubtitleLabel: UILabel!
    @IBOutlet var postVoteLabel: RoundedLabel!
    @IBOutlet var subtitleWrapperView: UIView!
    
    var item: Item? {
        didSet {
            self.postTitleLabel.text = self.item!.title!
            self.postVoteLabel.text = String(self.item!.score)
            self.postSubtitleLabel.text = self.item!.domain! + " - " + NSDate(timeIntervalSince1970: self.item!.time).timeAgo
        }
    }
    
    var postId: Int? {
        didSet {
            self.postTitleLabel.text = "Loading"
            Item.fetchPost(self.postId!) { (item, error, local) -> Void in
                self.item = item
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.postTitleLabel.textColor = UIColor.whiteColor()
        self.postSubtitleLabel.textColor = UIColor.DateLighGrayColor()
    }
    
}
