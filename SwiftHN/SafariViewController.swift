//
//  SafariViewController.swift
//  SwiftHN
//
//  Created by TETRA2000 on 12/23/15.
//  Copyright © 2015 Thomas Ricouard. All rights reserved.
//

import SafariServices

@available(iOS 9.0, *)
class SafariViewController: SFSafariViewController {
    private var previousBarStyle: UIStatusBarStyle?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        overrideStatusBarStyle()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        restoreStatusBarStyle()
    }
    
    private func overrideStatusBarStyle() {
        if previousBarStyle == nil {
            previousBarStyle = UIApplication.sharedApplication().statusBarStyle
        }
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    private func restoreStatusBarStyle() {
        if let previousBarStyle = previousBarStyle {
            UIApplication.sharedApplication().statusBarStyle = previousBarStyle
        }
    }
}
