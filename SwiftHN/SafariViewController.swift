//
//  SafariViewController.swift
//  SwiftHN
//
//  Created by TETRA2000 on 12/23/15.
//  Copyright © 2015 Thomas Ricouard. All rights reserved.
//

import SafariServices

@available(iOS 9.0, *)
class SafariViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    override func viewDidLoad() {
        self.delegate = self
        setupLoadingButton()
    }
    
    func setupLoadingButton() {
        self.navigationItem.rightBarButtonItem = nil
        let loadingItem = UIBarButtonItem(customView: self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem = loadingItem
    }
    
    func hideLoadingButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        hideLoadingButton()
    }
}
