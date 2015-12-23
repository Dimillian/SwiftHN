//
//  SplitViewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 12/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        self.minimumPrimaryColumnWidth = 320.0
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true;
    }
    
    override func showDetailViewController(vc: UIViewController, sender: AnyObject?) {
        if (vc.parentViewController is UINavigationController) {
            super.showDetailViewController(vc, sender: sender)
        }
        else {
            let nav = UINavigationController(rootViewController: vc)
            super.showDetailViewController(nav, sender: sender)
        }
    }
}