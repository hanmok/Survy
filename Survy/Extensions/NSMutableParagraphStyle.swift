//
//  NSMutableParagraphStyle.swift
//  Survy
//
//  Created by Mac mini on 2023/05/02.
//


import UIKit

extension NSMutableParagraphStyle {
    static var centerAlignmentStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }
}
