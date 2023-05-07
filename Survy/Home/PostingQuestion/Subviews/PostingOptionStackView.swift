//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

class PostingOptionStackView: UIStackView {
    
    var optionStackViewDelegate: OptionStackViewDelegate?
    
    public var selectedIndex: Int?
    
    var buttons: [SelectionButton] = []
    
    public var isConditionFulfilled: Bool = false {
        didSet {
            if oldValue != isConditionFulfilled {
                // TODO: Notify to ViewController
                optionStackViewDelegate?.notifyConditionChange(to: isConditionFulfilled)
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 14
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
    }
    
    private func configureLayout() {
        
    }
    
    public func addPostingSingleSelectionButton(_ button: PostingSelectionButton) {
        addArrangedSubview(button)
        self.buttons.append(button)
        button.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
    }
    
    // 현재 선택된 것과 비교, 다를 경우 이미 선택된 것을 unselected 로 변경
    @objc func singleSelectionButtonTapped(_ sender: PostingSelectionButton) {
        if let selectedIndex = selectedIndex, sender.tag != selectedIndex {
            guard let selectedButton = buttons.first(where: { $0.tag == selectedIndex}) else { fatalError() }
                selectedButton.buttonSelected(false)
        }
        sender.buttonSelected(true)
        selectedIndex = sender.tag
        isConditionFulfilled = true
    }
}
