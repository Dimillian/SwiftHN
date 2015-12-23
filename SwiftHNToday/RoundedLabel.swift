//
//  RoundedLabel.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 31/07/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared

@IBDesignable class RoundedLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.textColor = UIColor.HNColor()
        self.textAlignment = .Center
        self.text = "155"
        self.font = UIFont.systemFontOfSize(12.0)
        
        self.layer.borderColor = UIColor.HNColor().CGColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
