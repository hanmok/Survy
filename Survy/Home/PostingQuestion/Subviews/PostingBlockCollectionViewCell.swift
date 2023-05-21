//
//  PostingBlockCollectionViewCell.swift
//  Survy
//
//  Created by Mac mini on 2023/05/07.
//

import UIKit
import SnapKit
import Model

protocol PostingBlockCollectionViewCellDelegate {
    func questionTypeSelected(_ cell: PostingBlockCollectionViewCell, _ typeIndex: Int)
}

class PostingBlockCollectionViewCell: UICollectionViewCell {
    
    public var numberOfSelectableOptions: Int = 0
    
    public var postingQuestion: PostingQuestion?
    
    var postingBlockCollectionViewDelegate: PostingBlockCollectionViewCellDelegate?
    
    public var questionIndex: Int? {
        didSet {
            guard let index = questionIndex else { return }
            indexLabel.text = String(index) + "."
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDelegate()
        setupLayout()
    }
    
    private func setupDelegate() {
        questionTextField.delegate = self
        questionTypeOptionStackView.optionStackViewDelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func otherViewTapped() {
        dismissKeyboard()
    }
    
    private func setupLayout() {
        
        backgroundColor = .white
        layer.cornerRadius = 16
        addShadow(offset: CGSize(width: 5.0, height: 5.0))
        
        [indexLabel, questionTextField, questionTypeOptionStackView, selectableOptionStackView].forEach {
            addSubview($0)
        }
        
        [singleSelection1, singleSelection2, singleSelection3, singleSelection4].forEach { self.questionTypeOptionStackView.addPostingSingleSelectionButton($0)}
        
        
        indexLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
//            make.width.equalTo(15)
            make.width.equalTo(24)
        }
        
        questionTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(indexLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(20)
        }
        
        questionTypeOptionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(questionTextField.snp.bottom).offset(14)
            make.height.equalTo(30)
        }
        
        selectableOptionStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(questionTypeOptionStackView.snp.bottom).offset(20)
        }
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public var questionTextField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        textView.text = "질문을 입력해주세요."
        textView.textColor = UIColor.lightGray
        textView.tag = -1
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.sizeToFit()
        textView.textContainer.maximumNumberOfLines = 2
        textView.isScrollEnabled = false
        return textView
    }()
    
    private var singleSelection1: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단일 선택", tag: 1)
        return singleSelection
    }()
    
    private var singleSelection2: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "다중 선택", tag: 2)
        return singleSelection
    }()
    
    private var singleSelection3: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단답형", tag: 3)
        return singleSelection
    }()
    
    private var singleSelection4: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "서술형", tag: 4)
        return singleSelection
    }()
    
    public var questionTypeOptionStackView: PostingQuestionOptionStackView = {
        let postingOptionStackView = PostingQuestionOptionStackView()
        return postingOptionStackView
    }()
    
    //
    public var selectableOptionStackView: PostingSelectableOptionStackView = {
        let stackView = PostingSelectableOptionStackView()
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostingBlockCollectionViewCell: OptionStackViewDelegate {
    func notifySelectionChange(to index: Int) {
        
        var briefQuestionType: BriefQuestionType
        switch index {
            case 1: briefQuestionType = .singleSelection
            case 2: briefQuestionType = .multipleSelection
            default: briefQuestionType = .others
        }
        
        selectableOptionStackView.changeQuestionType(briefQuestionType)
        postingQuestion?.briefQuestionType = briefQuestionType
    }
    
    // 한번만 호출
    func notifyConditionChange(to condition: Bool) {
        guard let selectedIndex = questionTypeOptionStackView.selectedIndex, condition else { return }
        switch selectedIndex {
            case BriefQuestionType.singleSelection.rawValue: // 단일선택
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .singleSelection, tag: 1)
                selectableOptionFieldView.selectableOptionFieldDelegate = self
                
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
                
            case BriefQuestionType.multipleSelection.rawValue: // 다중선택
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .multipleSelection, tag: 1)
                selectableOptionFieldView.selectableOptionFieldDelegate = self
                
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
                
            default: // 단답형, 서술형
                let plain = SelectableOptionFieldView(briefQuestionType: .others, tag: 1)
                selectableOptionStackView.addSelectableOptionView(plain)
        }
        
        numberOfSelectableOptions = 1
//        postingQuestion?.selectableOptions =
        postingBlockCollectionViewDelegate?.questionTypeSelected(self, selectedIndex)
    }
}

extension PostingBlockCollectionViewCell: UITextFieldDelegate {
    // Question 에서 return 눌릴 때 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return true }
        
        // FIXME: 음.. 질문을 입력한 후 return 을 눌러도 여기가 호출됨. 그리고, 중간 수정을 하는 경우 어떤 값인지 알 수가 없음. 따라서, Tag 를 넣어줘야함. question: tag: -1
        guard let postingQuestion = postingQuestion else { fatalError() }
//        postingQuestion.question = text
        postingQuestion.updateQuestion(text: text)
        
        return dismissKeyboard()
    }
}

extension PostingBlockCollectionViewCell: SelectableOptionFieldDelegate {
    
    func notifyReturnButtonTapped(_ text: String, _ tag: Int) {
        // Selectable 에 대해서는 여기서 찍힘. 음..
        
        print("adding text: \(text)")
        let selectableOption = SelectableOption(postion: tag, value: text, placeHolder: nil)
        guard let postingQuestion = postingQuestion else { fatalError() }
        postingQuestion.addSelectableOption(selectableOption: selectableOption)
        print("current selectable options: ")
        
        postingQuestion.selectableOptions.forEach {
            print($0.value)
        }
        
        guard let selectedIndex = questionTypeOptionStackView.selectedIndex else { fatalError() }
        let currentNumberOfSelectableOptions = selectableOptionStackView.selectableOptionFieldViews.count
        let addedIndex = currentNumberOfSelectableOptions + 1
        
        switch selectedIndex {
            case BriefQuestionType.singleSelection.rawValue: // 단일선택
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .singleSelection, tag: addedIndex)
                selectableOptionFieldView.selectableOptionFieldDelegate = self
                
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)

                numberOfSelectableOptions += 1
                
            case BriefQuestionType.multipleSelection.rawValue: // 다중선택
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .multipleSelection, tag: addedIndex)
                selectableOptionFieldView.selectableOptionFieldDelegate = self
                
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
                
                numberOfSelectableOptions += 1
                
            default: // 단답형, 서술형
                dismissKeyboard() // dismissKeyboard
        }
    }
}


extension PostingBlockCollectionViewCell: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // return 이 아닌 다른곳 눌러도 이곳 호출됨.
        guard let text = textView.text else { return true }
        
        // FIXME: 음.. 질문을 입력한 후 return 을 눌러도 여기가 호출됨. 그리고, 중간 수정을 하는 경우 어떤 값인지 알 수가 없음. 따라서, Tag 를 넣어줘야함. question: tag: -1
        guard let postingQuestion = postingQuestion else { fatalError() }
//        postingQuestion.question = text
        postingQuestion.updateQuestion(text: text)
        
        return dismissKeyboard()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "질문을 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
}
