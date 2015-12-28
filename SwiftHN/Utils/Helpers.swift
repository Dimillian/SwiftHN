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
    
    class func addPostToReadingList(item: Item) -> Bool {
        let readingList = SSReadingList.defaultReadingList()
        var error: NSError?
        if let url: String = item.url?.absoluteString {
            do {
                try readingList!.addReadingListItemWithURL(NSURL(string: url)!, title: item.title, previewText: nil)
            } catch let error1 as NSError {
                error = error1
            }
            return error != nil
        }
        return false
    }
    
    class func showShareSheet(item: Item, controller: UIViewController, barbutton: UIBarButtonItem!) {
        let sheet = UIActivityViewController(activityItems: [NSString(string: item.title!), item.url!], applicationActivities: [OpenSafariActivity()])
        if sheet.popoverPresentationController != nil {
            sheet.modalPresentationStyle = UIModalPresentationStyle.Popover
            sheet.popoverPresentationController?.sourceView = controller.view
            if let barbutton = barbutton {
                sheet.popoverPresentationController?.barButtonItem = barbutton
            }
        }
        controller.presentViewController(sheet, animated: true, completion: nil)
    }
}