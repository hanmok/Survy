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
    func addFrontImage(image: UIImage, string: String, font: UIFont, color: UIColor = .black) {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = image
        
        let emptyString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let myString: NSMutableAttributedString = NSMutableAttributedString(string: " " + string, attributes: [.foregroundColor: color, .font: font])
        
        emptyString.append(attachmentString)
        emptyString.append(myString)

        self.attributedText = emptyString
    }
    
    func addFrontImage(image: UIImage, attrString: NSAttributedString) {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = image
        
        let emptyString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        emptyString.append(attachmentString)
        emptyString.append(attrString)

        self.attributedText = emptyString
    }
}


extension UILabel {
    
    func addCharacterSpacing(_ spacing: Double = 0.5) {
        let kernValue = self.font.pointSize * CGFloat(spacing)
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
//        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length))
        attributedText = string
    }
}


extension UIButton {
    func addCharacterSpacing(_ spacing: Double = 0.5) {
        guard let titleLabel = self.titleLabel else { return }
        let some = titleLabel.font
        let kernValue = titleLabel.font.pointSize * CGFloat(spacing)
        guard let text = self.currentTitle, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
//        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        string.addAttributes([.foregroundColor: UIColor.black, .kern: kernValue], range: NSRange(location: 0, length: string.length))
        self.setAttributedTitle(string, for: .normal)
    }
}
