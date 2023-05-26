//
//  SingleSelectionBoxButton.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit

class PostingSelectionButton: SelectionButton {

    var text: String
    
    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .deeperMainColor : .blurredMainColor
            setTitleColor(isSelected ? .white : .blurredTextColor, for: .normal)
        }
    }
    
    init(text: String, tag: Int) {
        self.text = text
        super.init(frame: .zero)
        self.tag = tag
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        setTitle(text, for: .normal)
        layer.cornerRadius = 6
        backgroundColor = .blurredMainColor
        setTitleColor(.blurredTextColor, for: .normal)
    }
}
