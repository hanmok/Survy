//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

protocol QuestionTypeOptionStackViewDelegate: AnyObject {
    func setQuestionType(briefQuestionType: BriefQuestionType)
}

class QuestionTypeOptionStackView: UIStackView {
    
    weak var optionStackViewDelegate: OptionStackViewDelegate?
    weak var questionOptionStackViewDelegate: QuestionTypeOptionStackViewDelegate?
    
    public var selectedIndex: Int?
    
    var questionTypeButtons: [SelectionButton] = []
    
    public var numberOfSelctableOptions: Int?
    
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
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateSelectedOption(briefType: BriefQuestionType) {
        guard let selectedButton = questionTypeButtons.first(where: {$0.tag == briefType.rawValue }) else { return }
        print("selectedButtonTag: \(selectedButton.tag), briefTypeRawValue: \(briefType.rawValue)")
        selectedButton.backgroundColor = UIColor.deeperMainColor
        selectedButton.setTitleColor(.white, for: .normal)
        // TODO: 다른 버튼들 색상 원상태로.
        
        let otherButtons = questionTypeButtons.filter { $0.tag != briefType.rawValue }
        otherButtons.forEach {
            $0.backgroundColor = UIColor.blurredMainColor
            $0.setTitleColor(.blurredTextColor, for: .normal)
        }
    }
    
    public func addPostingSingleSelectionButton(_ button: PostingSelectionButton) {
        addArrangedSubview(button)
        self.questionTypeButtons.append(button)
        button.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
    }
    
    
    
    @objc func singleSelectionButtonTapped(_ sender: PostingSelectionButton) {
        if let selectedIndex = selectedIndex, sender.tag != selectedIndex {
            guard let selectedButton = questionTypeButtons.first(where: { $0.tag == selectedIndex}) else { fatalError() }
                selectedButton.buttonSelected(false)
        }
        sender.buttonSelected(true)
        selectedIndex = sender.tag
        isConditionFulfilled = true
        guard let selectedIndex = selectedIndex,
              let briefType = BriefQuestionType(rawValue: selectedIndex)
        else { fatalError() }
        
        optionStackViewDelegate?.notifySelectionChange(to: selectedIndex)
        
        questionOptionStackViewDelegate?.setQuestionType(briefQuestionType: briefType)
    }
}

