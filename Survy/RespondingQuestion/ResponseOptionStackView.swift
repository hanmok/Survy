//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

class ResponseOptionStackView: UIStackView {
    
    var questionType: BriefQuestionType = .singleSelection

    var optionStackViewDelegate: OptionStackViewDelegate?
    
    public var selectedIndex: Int?
    public var selectedIndices: Set<Int>?
    
    public var textAnswer: String?
    public var textAnswers: [String]?
    
    var buttons: [SelectionButton] = []
    
    public func reset() {
        
        for button in buttons {
            button.removeFromSuperview()
            removeArrangedSubview(button)
        }
        isConditionFulfilled = false
        buttons.removeAll()
        selectedIndex = nil
    }
    
    public var isConditionFulfilled: Bool = false {
        didSet {
            if oldValue != isConditionFulfilled { // 이거.. 좀 이상해 전 값과 다르면, notify
                optionStackViewDelegate?.notifyConditionChange(to: isConditionFulfilled)
            }
        }
    }
    
    init(questionType: BriefQuestionType = .singleSelection) {
        self.questionType = questionType
        super.init(frame: .zero)
        self.axis = .vertical
    }
    
    public func setQuestionType(_ questionType: BriefQuestionType) {
        self.questionType = questionType
        switch questionType {
            case .multipleSelection:
                selectedIndices = Set<Int>()
            case .short, .essay:
                textAnswer = ""
            default:
                break
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addArrangedSubviews(_ selectionButtons: [SelectionButton]) {
        selectionButtons.forEach {
            addArrangedSubview($0)
        }
        self.buttons = selectionButtons
    }
    
    public func setSingleChoiceButtons(_ buttons: [SingleChoiceResponseButton]) {
        addArrangedSubviews(buttons)
        self.buttons = buttons
        buttons.forEach {
            $0.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    public func addSingleSelectionButton(_ button: SingleChoiceResponseButton) {
        addArrangedSubview(button)
        self.buttons.append(button)
        button.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
    }

    // 음.. 이렇게 진행하면 안될 것 같은데 ??
    public func addTextField(_ textField: UITextField) {
        addArrangedSubview(textField)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        // how to observe textField Change Here ?? 여기에 있는 textField 는 대체 뭐지 ??
    }
    
    @objc func textChanged(_ sender: UITextField) {
        // 호출 안됨
        guard let text = sender.text else { return }
        isConditionFulfilled = text != ""
    }
    
    public func setMultipleSelectionButtons(_ buttons: [MultipleChoiceResponseButton]) {
        
        addArrangedSubviews(buttons)
        buttons.forEach {
            $0.addTarget(self, action: #selector(multipleSelectionButtonTapped(_:)), for: .touchUpInside)
        }
        self.buttons = buttons
    }
    
    public func addMultipleSelectionButton(_ button: MultipleChoiceResponseButton) {
        addArrangedSubview(button)
        button.addTarget(self, action: #selector(multipleSelectionButtonTapped(_:)), for: .touchUpInside)
        self.buttons.append(button)
    }
    
    // 현재 선택된 것과 비교, 다를 경우 이미 선택된 것을 unselected 로 변경
    @objc func singleSelectionButtonTapped(_ sender: SingleChoiceResponseButton) {
        
        // selectedIndex: 1, tag: 0
//        print("selectedIndex: \()")
        
        if let selectedIndex = selectedIndex,
            sender.tag != selectedIndex {
            let allTags = buttons.map { $0.tag }
            guard let selectedButton = buttons.first(where: { $0.tag == selectedIndex } ) else { fatalError("selectedIndex: \(selectedIndex), buttons: \(allTags)") }
                selectedButton.buttonSelected(false)
        }
        
        sender.buttonSelected(true)
        selectedIndex = sender.tag
        print("selectedIndex changed to \(selectedIndex)")
        isConditionFulfilled = true
    }
    
    // 이미 선택되어 있는 상태면 해제, 안되어 있으면 선택
    @objc func multipleSelectionButtonTapped(_ sender: MultipleChoiceResponseButton) {
        guard selectedIndices != nil else { fatalError() }
        let isNotSelectedYet = !selectedIndices!.contains(sender.tag)
        sender.buttonSelected(isNotSelectedYet)
        
        selectedIndices!.toggle(sender.tag)
        
        // 아무것도 체크되어있지 않으면 다음으로 넘어갈 수 없음.
        isConditionFulfilled = selectedIndices!.isEmpty == false
    }
}

protocol OptionStackViewDelegate: AnyObject {
    func notifyConditionChange(to condition: Bool)
    func notifySelectionChange(to index: Int)
}

extension ResponseOptionStackView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("dismisskeyboard flag 3")
        dismissKeyboard()
        return true 
    }
}
