//
//  NewsViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, NewsCellDelegate {
    
    let hnManager = HNManager.sharedManager()
    var posts: NSArray! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HN:News"
        self.navigationController.condensesBarsOnSwipe = true
        
        //self.posts = Cache.decacheObject("news") as? NSArray
        self.hnManager.loadPostsWithFilter(.Top, completion: { (NSArray posts) in
            self.posts = posts
            //Cache.cacheObjects(self.posts, key: "news")
        })
    }
    
    // Mark: TableView Management
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        return 1
    }
    
    override func tableView(tableView: UITableView!,numberOfRowsInSection section: Int) -> Int {
        if self.posts {
            return self.posts.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        var title: NSString = (self.posts[indexPath.row] as HNPost).Title
        var size = title.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.tableView.bounds) - (NewsCellTitleMarginConstant * 2), CGFLOAT_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(NewsCellTitleFontSize)],
            context: nil)
        return size.height > 20.0 ?  NewsCellHeight + size.height - 20.0 : NewsCellHeight
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier(NewsCellsId) as? NewsCell
        cell!.post = self.posts[indexPath.row] as HNPost
        cell!.cellDelegate = self
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)  {
        if (segue.identifier == "toWebview") {
            var destination = segue.destinationViewController as WebviewController
            destination.post = self.posts[self.tableView.indexPathsForSelectedRows()[0].row] as HNPost
        }
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> AnyObject[]!
    {
        var readingList = UITableViewRowAction(style: UITableViewRowActionStyle.Normal,
            title: "Read Later",
            handler: {(action: UITableViewRowAction!, indexpath: NSIndexPath!) -> Void in
                
        })
        readingList.backgroundColor = UIColor.blueColor()
        
        return [readingList]
    }

    // Mark: NewsCellDelegate
    func newsCellDidSelectButton(cell: NewsCell,  actionType: NewsCellActionType) {
        var detailVC = self.storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        self.showDetailViewController(detailVC, sender: self)
    }
    

}
