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

class Helper {
    
    class func addPostToReadingList(post: HNPost) -> Bool {
        var readingList = SSReadingList.defaultReadingList()
        var error: NSError?
        if let url: String = post.UrlString {
            readingList.addReadingListItemWithURL(NSURL(string: url), title: post.Title, previewText: nil, error: &error)
            return !error
        }
        return false
    }
    
    class func showShareSheet(post: HNPost, controller: UIViewController) {
        var sheet = UIActivityViewController(activityItems: [NSString(string: post.Title), NSURL(string: post.UrlString)], applicationActivities: [OpenSafariActivity()])
        controller.presentViewController(sheet, animated: true, completion: nil)
    }
}