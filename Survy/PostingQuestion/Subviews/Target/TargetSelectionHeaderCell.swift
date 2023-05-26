//
//  TargetSelectionHeaderCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/16.
//

import UIKit
import SnapKit

class TargetSelectionHeaderCell: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        setupLayout()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if frame.width == UIScreen.screenWidth {
//            let inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
//            frame = self.frame.inset(by: inset)
//        }
//    }
    
    private func setupLayout() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    private func configureLayout() {
        label.textColor = .black
        
    }
    
    let label = UILabel()
}
