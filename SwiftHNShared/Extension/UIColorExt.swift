//
//  UIColorEXT.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func RGBColor(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    class func HNColor() -> UIColor {
        return UIColor.RGBColor(252, green: 102, blue: 33)
    }
}

class UIColorEXT {
    class func HNColor() -> UIColor {
        return UIColor.HNColor()
    }
}
