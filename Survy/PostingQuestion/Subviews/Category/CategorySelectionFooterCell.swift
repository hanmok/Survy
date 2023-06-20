//
//  TargetSelectionFooterCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/16.
//

import UIKit
import SnapKit

protocol GenreSelectionFooterCellDelegate: AnyObject {
    func genreSelectionFooterCellTapped()
}

class GenreSelectionFooterCell: UICollectionReusableView {
    
    weak var footerCellDelegate: GenreSelectionFooterCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(addingButton)
        addingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(CGFloat.genreAdddingButton)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setTargets() {
        addingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        footerCellDelegate?.genreSelectionFooterCellTapped()
    }
    
    let addingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.deeperMainColor
        let plusImage = UIImage.plus.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.addImageToCenter(image: plusImage, dividingRatio: 1.6)
        button.applyCornerRadius(on: .all, radius: CGFloat.genreAdddingButton / 2)
        return button
    }()
}
