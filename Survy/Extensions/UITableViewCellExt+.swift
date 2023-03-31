//
//  UITableViewCellExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
