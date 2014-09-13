//
//  Preferences.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 25/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit

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
    
    func addToReadLater(uid: String) {
        var array: [AnyObject]! = self.pUserDefault.arrayForKey(pReadLater)
        if (array == nil) {
            array = []
        }
        array.append(uid)
        self.pUserDefault.setObject(array, forKey: pReadLater)
    }
    
    class var sharedInstance: Preferences {
        return _preferencesSharedInstance
    }
}
