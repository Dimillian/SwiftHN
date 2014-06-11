//
//  NewsCell.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNLiveViews

let NewsCellsId = "newsCellId"

@objc protocol NewsCellDelegate {
    func newsCellDidSelectButton(cell: NewsCell, actionType: NewsCellActionType)
}

class NewsCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel = nil
    @IBOutlet var urlLabel : UILabel = nil
    @IBOutlet var voteLabel : BorderedButton = nil
    @IBOutlet var commentsLabel : BorderedButton = nil
    @IBOutlet var timeLabel : BorderedButton = nil
    
    weak var cellDelegate: NewsCellDelegate?
    
    var post: HNPost! {
        didSet{
            self.titleLabel.text = self.post.Title
            self.urlLabel.text = self.post.UrlString
            self.voteLabel.labelText = "\(self.post.Points) votes"
            self.commentsLabel.labelText = "\(self.post.CommentCount) comments"
            self.timeLabel.labelText = self.post.TimeCreatedString
            
            self.voteLabel.onButtonTouch = {
                self.selectedAction(.Vote)
            }
            
            self.commentsLabel.onButtonTouch = {
                self.selectedAction(.Comment)
            }
            
            self.timeLabel.onButtonTouch = {
                self.selectedAction(.Time)
            }
        }
    }

    init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func selectedAction(action: NewsCellActionType) {
        self.cellDelegate?.newsCellDidSelectButton(self, actionType: action)
    }
}
