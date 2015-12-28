//
//  DetailViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 11/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import HackerSwifter

class DetailViewController: HNTableViewController, NewsCellDelegate {
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:Post"
        
        self.setupBarButtonItems()
        self.onPullToFresh()
    }
    
    func onPullToFresh() {
        
        Item.fetchPost(self.item!.id) { (item, error, local) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.item = item
                if let kids = item.kids {
                    self.ids = kids
                }
                if (!local) {
                    self.refreshing = false
                }
            })
        }
    }
        
    func setupBarButtonItems() {
        let shareItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onShareButton")
        self.navigationItem.rightBarButtonItem = shareItem
    }
    
    func onShareButton() {
        Helper.showShareSheet(self.item!, controller: self, barbutton: self.navigationItem.rightBarButtonItem)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.section == 0) {
            return NewsCell.heightForText((self.item?.title)!, bounds: self.tableView.bounds)
        }
        return self.cellHeight[indexPath.row]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        
        return self.ids.count
    }
    
    private func loadComment(indexPath: NSIndexPath) {
        let id = self.ids[indexPath.row]
        Item.fetchPost(self.ids[indexPath.row]) { (item, error, local) -> Void in
            if (item != nil && id == item.id) {
                if let text = item.text {
                    self.cellHeight[indexPath.row] = CommentsCell.heightForText(text, bounds: self.tableView.bounds, level:0)
                }
                self.cachedItems[indexPath.row] = item
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
            cell!.item = self.item
            cell!.cellDelegate = self;
            return cell!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CommentsCellId) as! CommentsCell!
        cell!.index = indexPath.row
        cell!.comment  = nil
        let item = self.cachedItems[indexPath.row]
        if item.id != -1 {
            cell!.comment = item
        }
        else {
            self.loadComment(indexPath)
        }
        
        
        return cell
    }
    
    //MARK: NewsCellDelegate
    func newsCellDidSelectButton(cell: NewsCell, actionType: Int, item: Item) {
        if (actionType == NewsCellActionType.Username.rawValue) {
            if let realUsername = item.username {
                let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("UserViewController") as! UserViewController
                detailVC.user = realUsername
                self.showDetailViewController(detailVC, sender: self)
            }
        }
    }
    
    func newsCellPostDidLoad(cell: NewsCell) {
        
    }
    
    
    //MARK: Controller
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if #available(iOS 9, *) {
            if identifier == "toWebview" {
                if let url = (sender as? NewsCell)?.item!.url {
                    presentViewController(SafariViewController(URL: url), animated: true, completion: nil)
                    return false
                }
            }
        }
        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if (segue.identifier == "toWebview") {
            let destination = segue.destinationViewController as! WebviewController
            destination.item = self.item
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                //Nothing to do here, I just want to be noticed when the transition is done. 
                //It's actuallu quite nice to have the final size of size of the current layout,
                //Event if it's useless in our case.
            }, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, UInt(0)), { ()->() in
                    //self.cacheHeight(self.datasource)
                    dispatch_async(dispatch_get_main_queue(), { ()->() in
                        self.tableView.reloadData()
                    })
                })
        })
    }
    
}
