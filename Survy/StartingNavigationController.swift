//
//  StartingNavigationController.swift
//  MultiPeer
//
//  Created by 핏투비 on 2022/11/03.
//

import UIKit
import SnapKit
import Toast
/**
 NavigationController 에서 처음으로 띄어지는 Controller. Loading Bar, Alert 등을 일부 맡음.
 */
class StartingNavigationController: UINavigationController {
    public func toastMessage(title: String, message: String? = nil) {
        if let message = message {
            self.view.makeToast(message, duration: 3, position: .top, title: title, image: nil, style: .init()) { didTap in }
        } else {
            self.view.makeToast(title, duration: 3, position: .top, title: nil, image: nil, style: .init()) { didTap in }
        }
    }
    
    public let indicatorView = UIActivityIndicatorView()
    
    private func setupLayout() {
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        indicatorView.color = .deeperMainColor
        indicatorView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }
    
    public func setIndicatorSpin(_ shouldSpin: Bool) {
        if shouldSpin {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }
    
    // MARK: - Properties
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}
