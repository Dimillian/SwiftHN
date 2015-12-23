//
//  TodayViewController.swift
//  SwiftHNTodayWidget
//
//  Created by Thomas Ricouard on 18/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import NotificationCenter
import HackerSwifter
import SwiftHNShared


class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "widgetCellId"
    let topBottomWidgetInset: CGFloat = 10.0
    
    var completionHandler: ((NCUpdateResult) -> Void)?
    var posts: [Post] = [] {
        didSet {
            self.tableView.reloadData()
            self.preferredContentSize = CGSizeMake(0, self.tableView.contentSize.height)
        }
    }
    
    var expanded: Bool = false {
        didSet {
            self.tableView.reloadData()
            self.preferredContentSize = CGSizeMake(0, self.tableView.contentSize.height)
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
    
        Post.fetch(Post.PostFilter.Top, completion: {(posts: [Post]!, error: Fetcher.ResponseError!, local: Bool) in
            if let realDatasource = posts {
                self.posts = realDatasource
                self.completionHandler?(NCUpdateResult.NewData)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.expanded = false
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.topBottomWidgetInset, 0, self.topBottomWidgetInset, 0)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        self.completionHandler = completionHandler
        self.completionHandler?(NCUpdateResult.NewData)
    }
    
    //MARK: Actions
    
    func onViewMoreButton() {
        self.expanded = true
    }
    
    func onOpenApp() {
        self.extensionContext!.openURL(NSURL(string:"swifthn://")!, completionHandler: nil)
    }
    
    //MARK: TableView Management
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expanded {
            return 7
        }
        return self.posts.count > 5 ? 5 : self.posts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.expanded {
            return 0
        }
        return 60.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.expanded {
            return UIView(frame: CGRectZero)
        }
        let view = UIVisualEffectView(effect: UIVibrancyEffect.notificationCenterVibrancyEffect())
        view.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)
        let label = UILabel(frame: CGRectMake(48.0, 0, self.tableView.frame.size.width - 48.0, 30.0))
        view.contentView.addSubview(label)
        label.numberOfLines = 0
        label.textColor = UIColor.DateLighGrayColor()
        label.text = "See More..."
        label.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "onViewMoreButton")
        label.addGestureRecognizer(tap)
        
        let openApp = UILabel(frame: CGRectMake(48.0, 30.0, self.tableView.frame.size.width - 48.0, 30.0))
        view.contentView.addSubview(openApp)
        openApp.numberOfLines = 0
        openApp.textColor = UIColor.DateLighGrayColor()
        openApp.text = "Open SwiftHN"
        openApp.userInteractionEnabled = true
        let openAppTap = UITapGestureRecognizer(target: self, action: "onOpenApp")
        openApp.addGestureRecognizer(openAppTap)
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(todayCellId) as? TodayWidgetCell
        let post = self.posts[indexPath.row] as Post
        cell!.post = post
        return cell!
    }
    
    func tableView(tableView: UITableView
        , didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.posts[indexPath.row] as Post
        self.extensionContext!.openURL(post.url!, completionHandler: nil)
    }
}
