//
//  CategoriesViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 06/07/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import HackerSwifter

protocol CategoriesViewControllerDelegate {
    func categoriesViewControllerDidSelecteFilter(controller: CategoriesViewController, filer: Post.PostFilter, title: String)
}

class CategoriesViewController: UITableViewController {

    var delegate: CategoriesViewControllerDelegate?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "onCancelButton")
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func onCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell?.textLabel?.text == "Hacker News") {
            self.delegate?.categoriesViewControllerDidSelecteFilter(self, filer: .Top, title: "HN:News")
        }
        else if (cell?.textLabel?.text == "Latest") {
            self.delegate?.categoriesViewControllerDidSelecteFilter(self, filer: .New, title: "HN:Latest")
        }
        else if (cell?.textLabel?.text == "Jobs") {
            self.delegate?.categoriesViewControllerDidSelecteFilter(self, filer: .Jobs, title: "HN:Jobs")
        }
        else if (cell?.textLabel?.text == "Ask HN") {
            self.delegate?.categoriesViewControllerDidSelecteFilter(self, filer: .Ask, title: "HN:Ask")
        }
        else if (cell?.textLabel?.text == "Best") {
            self.delegate?.categoriesViewControllerDidSelecteFilter(self, filer: .Best, title: "HN:Best")
        }
        else if (cell?.textLabel?.text == "Show HN") {
            self.delegate?.categoriesViewControllerDidSelecteFilter(self, filer: .Show, title: "HN:Show")
        }
        
        self.onCancelButton()
    }

}
