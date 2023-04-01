//
//  UILabelExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/04/01.
//

import UIKit

//extension UILabel {
//    convenience init(leftSpacing: CGFloat = 10.0) {
//
//        self.init(frame: .zero)
//    }
//}




extension UILabel
{
    func addImage(image: UIImage, string: String, font: UIFont, color: UIColor = .black) {
        let attachment:NSTextAttachment = NSTextAttachment()
//        attachment.image = UIImage(named: imageName)
        attachment.image = image

//        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let emptyString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let myString: NSMutableAttributedString = NSMutableAttributedString(string: " " + string, attributes: [.foregroundColor: color, .font: font])
        
        emptyString.append(attachmentString)
        emptyString.append(myString)

        self.attributedText = emptyString
    }
}
