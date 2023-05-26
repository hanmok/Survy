//
//  CategorySearchCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/14.
//

import UIKit
import SnapKit
import Model

protocol SelectableTargetCellDelegate: AnyObject {
    func selectableTargetCellTapped(_ cell: SelectableTargetCell)
}

class SelectableTargetCell: UICollectionViewCell {
    
    var target: Target? {
        didSet {
            configure()
        }
    }
    
    var isTargetSelected: Bool {
        didSet {
            self.toggleSelection(isTargetSelected)
        }
    }
    
    weak var delegate: SelectableTargetCellDelegate?
    
    private func toggleSelection(_ isSelected: Bool) {
        backgroundColor = isSelected ? UIColor(white: 0.6, alpha: 1) : .white
        label.textColor = isSelected ? UIColor(white: 0.8, alpha: 1) : .black
    }
    
    override init(frame: CGRect) {
        self.isTargetSelected = false
        super.init(frame: frame)
        setupLayout()
        configure()
    }
    
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
        delegate?.selectableTargetCellTapped(self)
    }
    
    private func configure() {
        guard let target = target else { return }
        label.attributedText = NSAttributedString(string: target.name, attributes: [.paragraphStyle: NSMutableParagraphStyle.centerAlignment])
    }
    
    let label = UILabel()
    
    private let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
