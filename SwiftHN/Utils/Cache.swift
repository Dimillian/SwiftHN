//
//  Cache.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 10/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import Foundation


struct CacheHelper {
     static var filePath: String {
        get {
            var fileManager = NSFileManager.defaultManager()
            var paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
            var cachePath = paths[0] as String + "/caches/"
            if (!fileManager.fileExistsAtPath(cachePath)) {
                fileManager.createDirectoryAtPath(cachePath, withIntermediateDirectories: true, attributes: nil, error: nil)
            }
            return cachePath
        }
    }
}

class Cache {
    
    class func cacheObjects(object: AnyObject, key: String) {
        if (object.respondsToSelector("encodeWithCoder:")) {
            NSKeyedArchiver.archiveRootObject(object, toFile: CacheHelper.filePath + key)
        }
    }
    
    class func decacheObject(key: String) -> AnyObject! {
        var object : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(CacheHelper.filePath + key)
        if object {
            return object
        }
        return nil
    }
}
