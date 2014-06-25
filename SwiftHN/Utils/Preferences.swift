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
    
    var firstTimeLaunch: Bool {
        get {
            return self.pUserDefault.boolForKey(pFirstTimeLaunchString)
        }
    
        set {
            self.pUserDefault.setBool(newValue, forKey: pFirstTimeLaunchString)
        }
    }
    
    class var sharedInstance: Preferences {
        return _preferencesSharedInstance
    }
}
