//
//  GenreSearchCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/14.
//

import UIKit
import SnapKit
import Model

protocol SelectableGenreCellDelegate: AnyObject {
    func selectableGenreCellTapped(_ cell: SelectableGenreCell)
}

class SelectableGenreCell: UICollectionViewCell {
    
    var genreGenre: Genre? {
        didSet {
            configure()
        }
    }
    
    var isGenreSelected: Bool {
        didSet {
            self.toggleSelection(isGenreSelected)
        }
    }
    
    private func toggleSelection(_ isSelected: Bool) {
        backgroundColor = isSelected ? UIColor(white: 0.6, alpha: 1) : .white
        label.textColor = isSelected ? UIColor(white: 0.8, alpha: 1) : .black
    }
    
    override init(frame: CGRect) {
        self.isGenreSelected = false
        super.init(frame: frame)
        setupLayout()
        configure()
    }
    
    private let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    weak var delegate: SelectableGenreCellDelegate?
    
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
        delegate?.selectableGenreCellTapped(self)
    }
    
    private func configure() {
        guard let genreGenre = genreGenre else { return }
        label.attributedText = NSAttributedString(string: genreGenre.name, attributes: [.paragraphStyle: NSMutableParagraphStyle.centerAlignment])
    }
    
    let label = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
