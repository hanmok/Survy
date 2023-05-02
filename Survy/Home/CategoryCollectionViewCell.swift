//
//  CategoryCollectionViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/02.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    public var categoryCellDelegate: CategoryCellDelegate?
    
    var category: String? {
        didSet {
            self.configureLayout()
        }
    }
    
    var backgroundCircularView: UIView = {
        let view = UIView()
        return view
    }()
    
    private func configureLayout() {
        guard let category = category else { return }
        categoryButton.setTitle(category, for: .normal)
    }
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupLayout()
        
        backgroundCircularView.backgroundColor = .clear
        backgroundCircularView.layer.cornerRadius = 20
        backgroundCircularView.layer.borderColor = UIColor.clear.cgColor
        backgroundCircularView.layer.borderWidth = 1
        backgroundCircularView.clipsToBounds = true
        
        categoryButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
    }
    
    @objc func buttonTapped() {
        categoryButton.isSelected = !categoryButton.isSelected
        toggleAppearance(categoryButton.isSelected)
    }
    
    private func toggleAppearance(_ isSelected: Bool) {
        guard let category = category else { return }
        categoryCellDelegate?.categoryTapped(category: category, selected: isSelected)
        if isSelected {
            backgroundCircularView.backgroundColor = UIColor(white: 0.3, alpha: 1)
            categoryButton.setTitleColor(.white, for: .normal)
        } else {
            backgroundCircularView.backgroundColor = .clear
            categoryButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
        }
    }
    
    private func setupLayout() {
        addSubview(backgroundCircularView)
        backgroundCircularView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol CategoryCellDelegate: AnyObject {
    func categoryTapped(category: String, selected: Bool)
}
