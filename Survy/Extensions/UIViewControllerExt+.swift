//
//  UIViewControllerExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/04/05.
//

import UIKit

extension UIViewController {
    public var tabbarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 83.0
    }
}
