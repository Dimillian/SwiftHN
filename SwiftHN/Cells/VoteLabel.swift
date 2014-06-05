//
//  VoteLabel.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

class StampLabel: UILabel {
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        self.textAlignment = .Center
        self.font = UIFont.systemFontOfSize(10.0)

        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.orangeColor().CGColor
        
    }
}
