//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

class ResponseOptionStackView: UIStackView {
    
    var questionType: QuestionType = .singleSelection

    var optionStackViewDelegate: OptionStackViewDelegate?
    
    public var selectedIndex: Int?
    public var selectedIndices: Set<Int>?
    
    public var textAnswer: String?
    public var textAnswers: [String]?
    
    var buttons: [SelectionButton] = []
    
    public var isConditionFulfilled: Bool = false {
        didSet {
            if oldValue != isConditionFulfilled {
                // TODO: Notify to ViewController
                optionStackViewDelegate?.notifyConditionChange(to: isConditionFulfilled)
            }
        }
    }
    
    init(questionType: QuestionType = .singleSelection, axis: NSLayoutConstraint.Axis = .vertical) {
        self.questionType = questionType
        super.init(frame: .zero)
        self.axis = axis
        setupLayout()
    }
    
    public func setQuestionType(_ questionType: QuestionType) {
        self.questionType = questionType
        switch questionType {
            case .multipleSelection:
                selectedIndices = Set<Int>()
            case .essay, .shortSentence:
                textAnswer = ""
            default:
                break
        }
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
    
    
    
    public func addTextField(_ textField: UITextField) {
        addArrangedSubview(textField)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        // how to observe textField Change Here ??
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
    }
    
    public func addMultipleSelectionButton(_ button: MultipleChoiceResponseButton) {
        addArrangedSubview(button)
        button.addTarget(self, action: #selector(multipleSelectionButtonTapped(_:)), for: .touchUpInside)
    }
    
    // 현재 선택된 것과 비교, 다를 경우 이미 선택된 것을 unselected 로 변경
    @objc func singleSelectionButtonTapped(_ sender: SingleChoiceResponseButton) {
        if let selectedIndex = selectedIndex, sender.tag != selectedIndex {
            guard let selectedButton = buttons.first(where: { $0.tag == selectedIndex}) else { fatalError() }
                selectedButton.buttonSelected(false)
        }
        sender.buttonSelected(true)
        selectedIndex = sender.tag
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
        dismissKeyboard()
    }
}
