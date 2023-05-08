//
//  PostingBlockCollectionFooterCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import Model

protocol PostingBlockCollectionFooterDelegate: AnyObject {
    func addQuestionButtonTapped()
}

class PostingBlockCollectionFooterCell: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTargets()
        setupLayout()
    }
    
    weak var footerDelegate: PostingBlockCollectionFooterDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let responderButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if frame.width == UIScreen.screenWidth {
            let inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            frame = self.frame.inset(by: inset)
        }
    }
    
    private func setupTargets() {
        responderButton.addTarget(self, action: #selector(addingQuestionButtonTapped), for: .touchUpInside)
    }
    
    @objc func addingQuestionButtonTapped(_ sender: UIButton) {
        footerDelegate?.addQuestionButtonTapped()
    }
    
    private func setupLayout() {
        layer.cornerRadius = 16
        backgroundColor = .mainColor
        addShadow(offset: CGSize(width: 5.0, height: 5.0))
        let image = UIImage.plus.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        addImageToCenter(image: image)
        
        addSubview(responderButton)
        responderButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}
