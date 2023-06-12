//
//  LabelCollectionViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/16.
//


import UIKit
import SnapKit
import Model

class TagLabelCollectionViewCell: UICollectionViewCell {
    
    var text: String? {
        didSet {
            guard let text = text else { return }
            configureLayout(text)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
//    label.attributedText = NSAttributedString(string: categoryTag.name, attributes: [.paragraphStyle: NSMutableParagraphStyle.centerAlignment])
    private func setupLayout() {
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.cornerRadius = 10
        
        label.adjustsFontForContentSizeCategory = true
    }
    
    private func configureLayout(_ text: String) {
//        label.text = text
        label.attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: NSMutableParagraphStyle.centerAlignment])
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
