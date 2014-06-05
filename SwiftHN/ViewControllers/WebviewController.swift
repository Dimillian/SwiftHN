//
//  WebviewController.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 05/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

class WebviewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView : UIWebView = nil
    
    var post: HNPost!
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: self.post.UrlString)))
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
}
