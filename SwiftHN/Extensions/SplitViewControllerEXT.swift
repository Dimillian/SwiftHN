//
//  SplitViewControllerEXT.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 12/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit

extension UISplitViewController {
    var rootViewController: UIViewController {
        get {
            let masterVC = self.viewControllers[0] as UIViewController
            if (masterVC is UINavigationController) {
                let navVC = masterVC as UINavigationController
                return navVC.viewControllers[0] as UIViewController
            }
            return masterVC
        }
    }
}
