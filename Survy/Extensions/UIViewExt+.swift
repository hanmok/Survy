//
//  UIViewExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/04/04.
//

import UIKit
import SnapKit

// MARK: - Shadow
// from https://ios-development.tistory.com/653
extension UIView {
    public enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    public func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.8, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }

    public func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    public func addShadowToAll(color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UIView {
    public func addImageToCenter(image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().dividedBy(1.2)
        }
    }
}


extension UIView {
    @discardableResult
    public func dismissKeyboard() -> Bool {
        endEditing(true)
        return true
    }
}


public enum Side {
    case top
    case bottom
    case all
    case none
}

extension UIView {
    public func applyCornerRadius(on side: Side, radius: CGFloat = 10.0) {
        self.layer.cornerRadius = radius
        switch side {
            case .all:
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case .top:
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom:
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case .none:
                self.layer.maskedCorners = []
        }
        self.clipsToBounds = true
    }
}
