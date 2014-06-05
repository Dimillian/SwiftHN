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
        self.userInteractionEnabled = true
        
        self.onReset()
        
        self.textAlignment = .Center
        self.font = UIFont.systemFontOfSize(10.0)

        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.HNColor().CGColor
    }
    
    func onHighlight() {
        UIView.animateWithDuration(0.20, animations: {
            self.backgroundColor = UIColor.HNColor()
            self.textColor = UIColor.whiteColor()
        })
    }
    
    func onReset() {
        UIView.animateWithDuration(0.20, animations: {
            self.backgroundColor = UIColor.clearColor()
            self.textColor = UIColor.HNColor()
        })
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        self.onHighlight()
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
        self.onReset()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)  {
        super.touchesCancelled(touches, withEvent: event)
        self.onReset()
    }
}
