//
//  TargetSelectionFooterCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/16.
//

import UIKit
import SnapKit

protocol CategorySelectionFooterCellDelegate: AnyObject {
    func categorySelectionFooterCellTapped()
}

class CategorySelectionFooterCell: UICollectionReusableView {
    
    weak var footerCellDelegate: CategorySelectionFooterCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        setupLayout()
        setTargets()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        applyCornerRadius(on: .all, radius: 10)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureLayout() {

    }
    
    private func setTargets() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        footerCellDelegate?.categorySelectionFooterCellTapped()
    }
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .magenta
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
}
