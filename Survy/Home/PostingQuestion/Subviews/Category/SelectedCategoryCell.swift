//
//  CategorySearchCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/14.
//

import UIKit
import SnapKit
import Model

protocol SelectedCategoryCellDelegate: AnyObject {
    func selectedCategoryCellTapped(_ cell: SelectedCategoryCell)
}

class SelectedCategoryCell: UICollectionViewCell {
    
    var categoryTag: Tag? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configure()
    }
    
    private let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    weak var delegate: SelectedCategoryCellDelegate?
    
    private func setupLayout() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        label.adjustsFontForContentSizeCategory = true
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        delegate?.selectedCategoryCellTapped(self)
    }
    
    private func configure() {
        guard let categoryTag = categoryTag else { return }
        label.attributedText = NSAttributedString(string: categoryTag.name, attributes: [.paragraphStyle: NSMutableParagraphStyle.centerAlignment])
    }
    
    let label = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
