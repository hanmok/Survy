//
//  SingleChoiceButton.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit

class SelectionButton: UIButton {
    public func buttonSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
}

class SingleChoiceResponseButton: SelectionButton {
    
    var text: String
    
    public override var isSelected: Bool {
        didSet {
            let image = isSelected ? UIImage.filledCircle : UIImage.emptyCircle
            stateImageView.image = image
        }
    }
    
    override func buttonSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    var id: Int
    
    init(text: String, tag: Int, id: Int) {
        self.text = text
        self.id = id
        super.init(frame: .zero)
        self.tag = tag
        
        setupLayout()
    }

    private func setupLayout() {
        [stateImageView, label].forEach { addSubview($0) }
        
        stateImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(5)
            make.width.height.equalTo(30)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(stateImageView.snp.trailing).offset(5)
            make.top.trailing.bottom.equalToSuperview().inset(5)
        }
        label.text = text
    }
    
    // MARK: - Views
    private let stateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.emptyCircle
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
