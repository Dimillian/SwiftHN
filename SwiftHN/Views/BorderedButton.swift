
//
//  BorderedButton.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 06/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared

@IBDesignable class BorderedButton: UIView {

    typealias buttonTouchInsideEvent = (sender: UIButton) -> ()
    // MARK: Internals views
    var button : UIButton = UIButton(frame: CGRectZero)
    let animationDuration = 0.15
    
    // MARK: Callback
    var onButtonTouch: buttonTouchInsideEvent!
    
    // MARK: IBSpec
    @IBInspectable var borderColor: UIColor = UIColor.HNColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderCornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = borderCornerRadius
        }
    }
    
    @IBInspectable var labelColor: UIColor = UIColor.HNColor() {
        didSet {
            self.button.setTitleColor(labelColor, forState: .Normal)
        }
    }
    
    @IBInspectable var labelText: String = "Default" {
        didSet {
            self.button.setTitle(labelText, forState: .Normal)
        }
    }
    
    @IBInspectable var labelFontSize: CGFloat = 11.0 {
        didSet {
            self.button.titleLabel?.font = UIFont.systemFontOfSize(labelFontSize)
        }
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        self.setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.userInteractionEnabled = true
        
        self.button.addTarget(self, action: "onPress:", forControlEvents: .TouchDown)
        self.button.addTarget(self, action: "onRealPress:", forControlEvents: .TouchUpInside)
        self.button.addTarget(self, action: "onReset:", forControlEvents: .TouchUpInside)
        self.button.addTarget(self, action: "onReset:", forControlEvents: .TouchUpOutside)
        self.button.addTarget(self, action: "onReset:", forControlEvents: .TouchDragExit)
        self.button.addTarget(self, action: "onReset:", forControlEvents: .TouchCancel)
    }
    
    // MARK: views setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderColor = UIColor.HNColor()
        self.labelColor = UIColor.HNColor()
        self.borderWidth = 0.5
        self.borderCornerRadius = 5.0
        self.labelFontSize = 11.0
        
        self.button.frame = self.bounds
        self.button.titleLabel?.textAlignment = .Center
        self.button.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.button)
    }
    
    // MARK: Actions
    func onPress(sender: AnyObject) {
        UIView.animateWithDuration(self.animationDuration, animations: {
            self.labelColor = UIColor.whiteColor()
            self.backgroundColor = UIColor.HNColor()
        })
    }
    
    func onReset(sender: AnyObject) {
        UIView.animateWithDuration(self.animationDuration, animations: {
            self.labelColor = UIColor.HNColor()
            self.backgroundColor = UIColor.clearColor()
        })
    }
    
    func onRealPress(sender: AnyObject) {
        self.onButtonTouch(sender: sender as! UIButton)
    }
    
}
