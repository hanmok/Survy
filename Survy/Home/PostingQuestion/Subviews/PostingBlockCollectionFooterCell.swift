//
//  PostingBlockCollectionFooterCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import Model

class PostingBlockCollectionFooterCell: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        frame = self.frame.inset(by: inset)
    }
    
    private func setupLayout() {
        layer.cornerRadius = 16
        backgroundColor = .mainColor
        addShadow(offset: CGSize(width: 5.0, height: 5.0))
        let image = UIImage.plus.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        addImageToCenter(image: image)
    }
}
