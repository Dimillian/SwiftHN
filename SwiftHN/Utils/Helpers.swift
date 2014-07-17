//
//  Helpers.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 25/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import SafariServices
import HackerSwifter

class Helper {
    
    class func addPostToReadingList(post: Post) -> Bool {
        var readingList = SSReadingList.defaultReadingList()
        var error: NSError?
        if let url: String = post.url?.absoluteString {
            readingList.addReadingListItemWithURL(NSURL(string: url), title: post.title, previewText: nil, error: &error)
            return !error
        }
        return false
    }
    
    class func showShareSheet(post: Post, controller: UIViewController) {
        var sheet = UIActivityViewController(activityItems: [NSString(string: post.title), post.url!], applicationActivities: [OpenSafariActivity()])
        controller.presentViewController(sheet, animated: true, completion: nil)
    }
}