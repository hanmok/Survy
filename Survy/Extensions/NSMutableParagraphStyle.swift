//
//  NSMutableParagraphStyle.swift
//  Survy
//
//  Created by Mac mini on 2023/05/02.
//


import UIKit

extension NSMutableParagraphStyle {
    static var centerAlignment: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
    }
    
    static var rightAlignment: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        return style
    }
}
