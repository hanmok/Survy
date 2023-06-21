//
//  GenreCollectionViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/02.
//

import UIKit
import Model

class GenreCollectionViewCell: UICollectionViewCell {
    
    public var genreCellDelegate: GenreCellDelegate?
    
    var genre: Genre? {
        didSet {
            self.configureLayout()
        }
    }
    
    var backgroundCircularView: UIView = {
        let view = UIView()
        return view
    }()
    
    private func configureLayout() {
        guard let genre = genre else { return }
        genreButton.setTitle(genre.name, for: .normal)
    }
    
    private let genreButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        genreButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupLayout()
        
        backgroundCircularView.backgroundColor = .clear
        backgroundCircularView.layer.cornerRadius = 20
        backgroundCircularView.clipsToBounds = true
        genreButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
    }
    
    @objc func buttonTapped() {
        genreButton.isSelected = !genreButton.isSelected
        toggleAppearance(genreButton.isSelected)
    }
    
    private func toggleAppearance(_ isSelected: Bool) {
        guard let genre = genre else { return }
        
        genreCellDelegate?.genreTapped(genre: genre, selected: isSelected)
        
        if isSelected {
            backgroundCircularView.backgroundColor = UIColor(white: 0.3, alpha: 1)
            genreButton.setTitleColor(.white, for: .normal)
        } else {
            backgroundCircularView.backgroundColor = .clear
            genreButton.setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
        }
    }
    
    private func setupLayout() {
        addSubview(backgroundCircularView)
        backgroundCircularView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
        
        addSubview(genreButton)
        genreButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol GenreCellDelegate: AnyObject {
    func genreTapped(genre: Genre, selected: Bool)
}
