//
//  UIStackViewExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/05/06.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
