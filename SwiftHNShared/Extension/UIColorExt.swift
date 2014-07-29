//
//  UIColorEXT.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

private extension UIColor {
    
    private class func RGBColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    private class func HNColor() -> UIColor {
        return UIColor.RGBColor(253, green: 84, blue: 4)
    }
    
    private class func ReadingListColor() -> UIColor {
        return UIColor.RGBColor(74, green: 144, blue: 226)
    }
    
    private class func DateLighGrayColor() -> UIColor {
        return UIColor.RGBColor(170, green: 170, blue: 170)
    }
    
    private class func CommentLightGrayColor() -> UIColor {
        return UIColor.RGBColor(111, green: 111, blue: 111)
    }
  
    private class func LoadMoreLightGrayColor() -> UIColor {
        return UIColor.RGBColor(245, green: 245, blue: 245)
    }
}

public class UIColorEXT {
    public class func HNColor() -> UIColor {
        return UIColor.HNColor()
    }
    
    public class func ReadtListColor() -> UIColor {
        return UIColor.ReadingListColor()
    }
    
    public class func DateLightGrayColor() -> UIColor {
        return UIColor.DateLighGrayColor()
    }
    
    public class func CommentLightGrayColor() -> UIColor {
        return UIColor.CommentLightGrayColor()
    }
  
    public class func LoadMoreLightGrayColor() -> UIColor {
        return UIColor.LoadMoreLightGrayColor()
    }
}
