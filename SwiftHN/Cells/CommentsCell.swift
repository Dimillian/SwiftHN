//
//  CommentsCell.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 30/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import HackerSwifter

let CommentsCellId = "commentCellId"
let CommentCellMarginConstant: CGFloat = 16.0
let CommentCellTopMargin: CGFloat = 5.0
let CommentCellFontSize: CGFloat = 13.0
let CommentCellUsernameHeight: CGFloat = 25.0
let CommentCellBottomMargin: CGFloat = 16.0

class CommentsCell: UITableViewCell {

    var comment: Comment! {
        didSet {
            let username = comment.username
            let date = " - " + comment.prettyTime!
            
            let usernameAttributed = NSAttributedString(string: username!,
                attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(CommentCellFontSize),
                    NSForegroundColorAttributeName: UIColor.HNColor()])
            let dateAttribute = NSAttributedString(string: date,
                attributes: [NSFontAttributeName: UIFont.systemFontOfSize(CommentCellFontSize),
                    NSForegroundColorAttributeName: UIColor.DateLighGrayColor()])
            let fullAttributed = NSMutableAttributedString(attributedString: usernameAttributed)
            fullAttributed.appendAttributedString(dateAttribute)
            
            self.commentLabel.font = UIFont.systemFontOfSize(CommentCellFontSize)
            
            self.usernameLabel.attributedText = fullAttributed
            self.commentLabel.text = comment.text
        }
    }
    
    var indentation: CGFloat {
        didSet {
            self.commentLeftMarginConstraint.constant = indentation
            self.usernameLeftMarginConstrain.constant = indentation
            self.commentHeightConstrain.constant =
                self.contentView.frame.size.height - CommentCellUsernameHeight - CommentCellTopMargin - CommentCellMarginConstant + 5.0
            self.contentView.setNeedsUpdateConstraints()
        }
    }
    
    @IBOutlet var usernameLabel: UILabel! = nil
    @IBOutlet var commentLabel: UITextView! = nil
    @IBOutlet var commentLeftMarginConstraint: NSLayoutConstraint! = nil
    @IBOutlet var commentHeightConstrain: NSLayoutConstraint! = nil
    @IBOutlet var usernameLeftMarginConstrain: NSLayoutConstraint! = nil
  
    required init?(coder aDecoder: NSCoder) { // required for Xcode6-Beta5
        self.indentation = CommentCellMarginConstant
        super.init(coder: aDecoder)
    }
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.indentation = CommentCellMarginConstant
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commentLabel.font = UIFont.systemFontOfSize(CommentCellFontSize)
        self.commentLabel.textColor = UIColor.CommentLightGrayColor()
        self.commentLabel.linkTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(CommentCellFontSize),
            NSForegroundColorAttributeName: UIColor.ReadingListColor()]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.commentLabel.text = comment.text
        
        self.commentLabel.textContainer.lineFragmentPadding = 0
        self.commentLabel.textContainerInset = UIEdgeInsetsZero
        self.commentLabel.contentInset = UIEdgeInsetsZero
        
        self.commentLabel.frame.size.width = self.contentView.bounds.width - (self.commentLeftMarginConstraint.constant * 2) - (CommentCellMarginConstant * CGFloat(self.comment.depth))
        self.indentation = CommentCellMarginConstant + (CommentCellMarginConstant * CGFloat(self.comment.depth))
    }
    
    class func heightForText(text: String, bounds: CGRect, level: Int) -> CGFloat {
        let size = text.boundingRectWithSize(CGSizeMake(CGRectGetWidth(bounds) - (CommentCellMarginConstant * 2) -
            (CommentCellMarginConstant * CGFloat(level)), CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(CommentCellFontSize)],
            context: nil)
        return CommentCellMarginConstant + CommentCellUsernameHeight + CommentCellTopMargin + size.height + CommentCellBottomMargin
    }
}
