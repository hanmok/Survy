//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

class OptionStackView: UIStackView {
    var questionType: QuestionType = .singleSelection
    
    var selectedIndex: Int?
    var selectedIndices: Int?
    
    var buttons: [SelectionButton] = []
    
    init(questionType: QuestionType = .singleSelection) {
        self.questionType = questionType
        super.init(frame: .zero)
        self.axis = .vertical
        setupLayout()
    }
    
    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
    }
    
    private func configureLayout() {
        
    }
    
    private func addArrangedSubviews(_ selectionButtons: [SelectionButton]) {
        selectionButtons.forEach {
            addArrangedSubview($0)
        }
        self.buttons = selectionButtons
    }
    
    public func setSingleChoiceButtons(_ buttons: [SingleChoiceButton]) {
        addArrangedSubviews(buttons)
        buttons.forEach {
            $0.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
        }
        self.buttons = buttons
    }
    
    
    public func setMultipleSelectionButtons(_ buttons: [MultipleChoiceButton]) {
        addArrangedSubviews(buttons)
        buttons.forEach {
            $0.addTarget(self, action: #selector(multipleSelectionButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    // Tag 는 각 Class 생성 시 미리 만들어져 있어야함
    @objc func singleSelectionButtonTapped(_ sender: SingleChoiceButton) {
        print("sender.tag1: \(sender.tag), selectedIndex: \(selectedIndex)")
        
        if let selectedIndex = selectedIndex, sender.tag != selectedIndex {
          // 현재 선택된 것과 비교, 다를 경우 이미 선택된 것을 unselected 로 변경
            guard let selectedButton = buttons.first(where: { $0.tag == selectedIndex}) else { fatalError() }
                selectedButton.buttonSelected(false)
        }
        sender.buttonSelected(true)
        selectedIndex = sender.tag
    }
    
    @objc func multipleSelectionButtonTapped(_ sender: MultipleChoiceButton) {
        
    }
    
    
}
