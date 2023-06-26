

import UIKit

extension UITextField {
    public func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    public func setLeftImage(_ imageName: String, tintColor: UIColor = .white, size: CGFloat, padding: CGFloat = 5) {
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: size + padding * 2, height: self.frame.size.height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.size.height))
        
        imageView.contentMode = .scaleAspectFit
        let uiImage = UIImage(systemName: imageName)!
        
        imageView.image = uiImage
        imageView.tintColor = tintColor
        
        imageContainerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor, constant: padding).isActive = true
        imageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor, constant: -padding).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        
        self.leftView = imageContainerView
        self.leftViewMode = .always
    }
    
    public func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    public convenience init(leftPadding: CGFloat = 5, rightPadding: CGFloat = 5, withPadding: Bool) {
        self.init(frame: .zero)
        
        if withPadding {
            setLeftPaddingPoints(leftPadding)
            setRightPaddingPoints(rightPadding)
        }
    }
}
