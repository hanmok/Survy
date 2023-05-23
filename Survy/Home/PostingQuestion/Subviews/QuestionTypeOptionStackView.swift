//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

protocol QuestionTypeOptionStackViewDelegate: AnyObject {
//    func makeSelectableOptions(numberOfOptions: Int, type: BriefQuestionType)
    
    func changeQuestionType(briefQuestionType: BriefQuestionType)
}

class QuestionTypeOptionStackView: UIStackView {
    
    weak var optionStackViewDelegate: OptionStackViewDelegate?
    weak var questionOptionStackViewDelegate: QuestionTypeOptionStackViewDelegate?
    
    public var selectedIndex: Int?
    
    var questionTypeButtons: [SelectionButton] = []
    
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
    
//    public func removeAllArrangedSubViewsExceptFor(tag: Int) {
//        let buttons = questionTypeButtons.filter { $0.tag != tag }
//        guard let selectedButton = questionTypeButtons.first(where: {$0.tag == tag }) else { return }
//
//        selectedButton.backgroundColor = UIColor.deeperMainColor
//        selectedButton.setTitleColor(.white, for: .normal)
//
//        buttons.forEach {
//            self.removeArrangedSubview($0)
//            $0.removeFromSuperview()
//        }
//
//        questionTypeButtons = [selectedButton]
//        
//        addArrangedSubview(numberOfSelectableOptionButton)
////        setupNumOfSelectableOptionMenu()
////        setupTypeOfQuestionMenu()
//        self.layoutSubviews()
//    }
    
//    private func setupTypeOfQuestionMenu() {
//
//        guard let firstButton = questionTypeButtons.first else { fatalError() }
//        print("numberOfQuestionTypeButtons: \(questionTypeButtons.count)")
//
//        var children = [UIMenuElement]()
//
//        let options = ["단일 선택", "다중 선택", "단답형", "서술형"]
//
//        for option in options {
//            let title = option
//            children.append(UIAction(title: title, handler: { [weak self] handler in
//                firstButton.setTitle(title, for: .normal)
//                guard let selectedIndex = self?.selectedIndex else { fatalError() }
//                guard let type = BriefQuestionType(rawValue: selectedIndex) else { fatalError() }
//                self?.questionOptionStackViewDelegate?.changeQuestionType(briefType: type)
//            }))
//        }
//        let menu = UIMenu(title: "", children: children)
//        firstButton.removeTarget(nil, action: nil, for: .allEvents)
//        firstButton.menu = menu
//        firstButton.showsMenuAsPrimaryAction = true
//    }
    
//    private func setupNumOfSelectableOptionMenu() {
//        var children = [UIMenuElement]()
//        for i in 1 ... 9 {
//            let title = "\(i) 옵션"
//            children.append(UIAction(title: title, handler: { [weak self] handler in
//                self?.numberOfSelectableOptionButton.setTitle(title, for: .normal)
//                guard let selectedIndex = self?.selectedIndex else { fatalError() }
//                guard let type = BriefQuestionType(rawValue: selectedIndex) else { fatalError() }
//
//                self?.questionOptionStackViewDelegate?.makeSelectableOptions(numberOfOptions: i, type: type)
//            }))
//        }
//
//        let menu = UIMenu(title: "", children: children)
//        numberOfSelectableOptionButton.menu = menu
//        numberOfSelectableOptionButton.showsMenuAsPrimaryAction = true
//    }
    
    
    public func addPostingSingleSelectionButton(_ button: PostingSelectionButton) {
        addArrangedSubview(button)
        self.questionTypeButtons.append(button)
        button.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
    }
    
    public let numberOfSelectableOptionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("옵션 수", for: .normal)
        button.backgroundColor = .magenta
        button.layer.cornerRadius = 6
        return button
    }()
    
    public var numberOfSelctableOptions: Int?
    
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
        
        questionOptionStackViewDelegate?.changeQuestionType(briefQuestionType: briefType)
    }
}

