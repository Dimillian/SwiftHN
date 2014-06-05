//
//  NewsCell.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

let NewsCellsId = "newsCellId"

class NewsCell: UITableViewCell {
    
    
    @IBOutlet var titleLabel : UILabel = nil
    @IBOutlet var urlLabel : UILabel = nil
    
    var post: HNPost! {
        didSet{
            self.titleLabel.text = self.post.Title
            self.urlLabel.text = self.post.UrlString
        }
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
