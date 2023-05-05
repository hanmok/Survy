//
//  MultipleChoiceButton.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//



//
//  SingleChoiceButton.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit

class MultipleChoiceButton: SelectionButton {
    
    public override var isSelected: Bool {
        didSet {
            let image = isSelected ? UIImage.checkedSquare : UIImage.uncheckedSquare
            stateImageView.image = image
        }
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
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
    
    private let stateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.uncheckedSquare
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
