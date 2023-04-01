//
//  UIViewExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/04/01.
//

import UIKit

extension UIButton {
    func addInsets(top: CGFloat = 10.0, bottom: CGFloat = 10.0, left: CGFloat = 10.0, right: CGFloat = 10.0) {
        self.contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func setTitleWithImage(image: UIImage, title: String) {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = image
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        let myString: NSMutableAttributedString = NSMutableAttributedString(string: title + " ")
        myString.append(attachmentString)
        self.setAttributedTitle(myString, for: .normal)
    }
}
