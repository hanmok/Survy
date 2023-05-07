//
//  UICollectionReusableViewExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
