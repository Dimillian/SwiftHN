//
//  UIColorEXT.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public class func RGBColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    public class func HNColor() -> UIColor {
        return UIColor.RGBColor(253, green: 84, blue: 4)
    }
    
    public class func ReadingListColor() -> UIColor {
        return UIColor.RGBColor(74, green: 144, blue: 226)
    }
    
    public class func DateLighGrayColor() -> UIColor {
        return UIColor.RGBColor(170, green: 170, blue: 170)
    }
    
    public class func CommentLightGrayColor() -> UIColor {
        return UIColor.RGBColor(111, green: 111, blue: 111)
    }
  
    public class func LoadMoreLightGrayColor() -> UIColor {
        return UIColor.RGBColor(245, green: 245, blue: 245)
    }
}