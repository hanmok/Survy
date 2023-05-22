//
//  OptionStackView.swift
//  Survy
//
//  Created by Mac mini on 2023/05/05.
//

import UIKit
import Model

protocol PostingQuestionOptionStackViewDelegate: AnyObject {
    func makeSelectableOptions(numberOfOptions: Int, type: BriefQuestionType)
}

class PostingQuestionOptionStackView: UIStackView {
    
    weak var optionStackViewDelegate: OptionStackViewDelegate?
    weak var questionOptionStackViewDelegate: PostingQuestionOptionStackViewDelegate?
    
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
    
    public func removeAllArrangedSubViewsExceptFor(tag: Int) {
        let buttons = questionTypeButtons.filter { $0.tag != tag }
        guard let selectedButton = questionTypeButtons.first(where: {$0.tag == tag }) else { return }
        
        selectedButton.backgroundColor = UIColor.deeperMainColor
        selectedButton.setTitleColor(.white, for: .normal)
        
        buttons.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        addArrangedSubview(numberOfSelectableOptionButton)
        setupMenu()
        self.layoutSubviews()
    }
    
    private func setupMenu() {
        var children = [UIMenuElement]()
        for i in 1 ... 9 {
            let title = "\(i) 항목"
            children.append(UIAction(title: title, handler: { [weak self] handler in
                self?.numberOfSelectableOptionButton.setTitle(title, for: .normal)
                guard let selectedIndex = self?.selectedIndex else { fatalError() }
                guard let type = BriefQuestionType(rawValue: selectedIndex) else { fatalError() }
                
                self?.questionOptionStackViewDelegate?.makeSelectableOptions(numberOfOptions: i, type: type)
            }))
        }
        
        let menu = UIMenu(title: "", children: children)
        numberOfSelectableOptionButton.menu = menu
        numberOfSelectableOptionButton.showsMenuAsPrimaryAction = true
    }
    
    public func addPostingSingleSelectionButton(_ button: PostingSelectionButton) {
        addArrangedSubview(button)
        self.questionTypeButtons.append(button)
        button.addTarget(self, action: #selector(singleSelectionButtonTapped(_:)), for: .touchUpInside)
    }
    
    public let numberOfSelectableOptionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("항목 수", for: .normal)
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
        guard let selectedIndex = selectedIndex else { return }
        optionStackViewDelegate?.notifySelectionChange(to: selectedIndex)
    }
}
