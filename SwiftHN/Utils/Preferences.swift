//
//  Preferences.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 25/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit
import HackerSwifter

let _preferencesSharedInstance = Preferences()

class Preferences {
    
    let pUserDefault = NSUserDefaults.standardUserDefaults()
    let pFirstTimeLaunchString = "isFirstTimeLaunch"
    let pReadLater = "readLater"
    
    var firstTimeLaunch: Bool {
        get {
            return self.pUserDefault.boolForKey(pFirstTimeLaunchString)
        }
    
        set {
            self.pUserDefault.setBool(newValue, forKey: pFirstTimeLaunchString)
        }
    }
    
    func addToReadLater(post: Post) {
        var array: [AnyObject]! = self.pUserDefault.arrayForKey(pReadLater)
        if (array == nil) {
            array = []
        }
        array.append(post.postId!)
        self.pUserDefault.setObject(array, forKey: pReadLater)
    }
    
    func isInReadingList(uid: String) -> Bool {
        let array: [AnyObject]! = self.pUserDefault.arrayForKey(pReadLater)
        if (array == nil) {
            return false
        }
        return (array as! [String]).contains(uid)
    }
    
    class var sharedInstance: Preferences {
        return _preferencesSharedInstance
    }
}
