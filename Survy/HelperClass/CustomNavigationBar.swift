//
//  CustomNavigationBar.swift
//  Survy
//
//  Created by Mac mini on 2023/05/22.
//

import UIKit
import SnapKit

protocol CustomNavigationBarDelegate: AnyObject {
    func dismiss()
}

public class CustomNavigationBar: UIView {
    
    weak var delegate: CustomNavigationBarDelegate?
    
    init(title: String = "") {
        super.init(frame: .zero)
        titleLabel.text = title
        setupTargets()
        setupLayout()
    }
    
    private func setupLayout() {
        [dismissButton, titleLabel].forEach { self.addSubview($0)}
        
        dismissButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupTargets() {
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }
    
    @objc func dismissTapped() {
        delegate?.dismiss()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = UIImage.leftChevron
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2)
        }
        return button
    }()
    
}
