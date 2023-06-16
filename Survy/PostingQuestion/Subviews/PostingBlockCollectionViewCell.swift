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
    func updateUI(cell: PostingBlockCollectionViewCell, cellIndex: Int, postingQuestion: PostingQuestion)
    func setPostingQuestionToIndex(postingQuestion: PostingQuestion, index: Int)
    func updateQuestionText(cellIndex: Int, questionText: String, postingQuestion: PostingQuestion)
}

class PostingBlockCollectionViewCell: UICollectionViewCell {
    
    public var numberOfSelectableOptions: Int {
        return selectableOptionStackView.selectableOptionFieldViews.count
    }
    
    public var cellIndex: Int? {
        didSet {
            guard let index = cellIndex else { return }
            let adjustedIndex = index + 1
            indexLabel.text = String(adjustedIndex) + "."
        }
    }
    
    var postingBlockCollectionViewCellDelegate: PostingBlockCollectionViewCellDelegate?
        
    public var postingQuestion: PostingQuestion? {
        didSet {
            guard let postingQuestion = postingQuestion else { fatalError() }
            initializeStates()
            configure(with: postingQuestion)
        }
    }
    
    public var briefQuestionType: BriefQuestionType {
        return postingQuestion?.briefQuestionType ?? .multipleSelection // 이게 문제가 아님
    }
    
    private func initializeStates() {
        selectableOptionStackView.selectableOptionFieldViews.forEach {
            selectableOptionStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        selectableOptionStackView = SelectableOptionStackView()
    }
    
    private func configure(with postingQuestion: PostingQuestion) {
        questionTextField.text = postingQuestion.question // 왜 nil 이죠?
        
        if questionTextField.text == "" { questionTextField.text = "질문을 입력해주세요." }
        // 이거 왜 안먹지?
        print("postingQuestion.question: \(postingQuestion.question)")
        
        questionTextField.textColor = questionTextField.text == "질문을 입력해주세요." ? .lightGray : .black
        
        if let briefQuestionType = postingQuestion.briefQuestionType {
            questionTypeOptionStackView.updateSelectedOption(briefType: briefQuestionType)
        }
        
        indexLabel.text = "\((postingQuestion.index + 1))."
        
        postingQuestion.selectableOptions.forEach {
            if let briefQuestionType = postingQuestion.briefQuestionType {
                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: briefQuestionType, selectableOption: $0)
                selectableOptionFieldView.selectableOptionFieldDelegate = self
                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
            }
        }
        
        addSubview(selectableOptionStackView)
        selectableOptionStackView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(questionTypeOptionStackView.snp.bottom).offset(20)
        }
        
        let keyboardShowingUpDelay = 0.5
        
        if UserDefaults.standard.isAddingSelectableOption {
            Timer.scheduledTimer(withTimeInterval: keyboardShowingUpDelay, repeats: false) { _ in
                if let last = self.selectableOptionStackView.selectableOptionFieldViews.last?.selectableOptionTextField {
                    last.becomeFirstResponder()
                }
            }
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
        questionTypeOptionStackView.questionOptionStackViewDelegate = self
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
        
        [questionTypeButton1, questionTypeButton2, questionTypeButton3, questionTypeButton4].forEach { self.questionTypeOptionStackView.addPostingSingleSelectionButton($0)
        }
        
        
        indexLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
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
        label.textAlignment = .right
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
    
    private let questionTypeButton1: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단일 선택", tag: 0)
        return singleSelection
    }()
    
    private let questionTypeButton2: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "다중 선택", tag: 1)
        return singleSelection
    }()
    
    private let questionTypeButton3: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단답형", tag: 2)
        return singleSelection
    }()
    
    private let questionTypeButton4: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "서술형", tag: 3)
        return singleSelection
    }()
    
    public let questionTypeOptionStackView: QuestionTypeOptionStackView = {
        let postingOptionStackView = QuestionTypeOptionStackView()
        return postingOptionStackView
    }()
    
    public var selectableOptionStackView: SelectableOptionStackView = {
        let stackView = SelectableOptionStackView()
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostingBlockCollectionViewCell: OptionStackViewDelegate {
    // 바꾸면 여기 호출, 처음에도 여기 호출
    func notifySelectionChange(to index: Int) {

    }
    
    // configure 시, notifyConditionChanged 에서 한번씩 호출.
    
    private func updateWithQuestionType(tag: Int) {
        notifySelectionChange(to: tag)
    }
    
    // 한번만 호출
    func notifyConditionChange(to condition: Bool) {
        guard let selectedIndex = questionTypeOptionStackView.selectedIndex, condition else { return }
        updateWithQuestionType(tag: selectedIndex)
    }
}

extension PostingBlockCollectionViewCell: UITextFieldDelegate {
    // Question 에서 return 눌릴 때 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserDefaults.standard.isAddingSelectableOption = false
        guard let text = textField.text else { return true }
        return dismissKeyboard()
    }
}

extension PostingBlockCollectionViewCell: SelectableOptionFieldDelegate {
    // TODO: 다음 selectableOption 값으로 이동
    func selectableOptionFieldReturnTapped(_ text: String, _ position: Int) {
        
        guard let postingQuestion = postingQuestion,
              let cellIndex = cellIndex else { fatalError() }
        
        let selectableOption = SelectableOption(position: position, value: text)
        postingQuestion.modifySelectableOption(index: position, selectableOption: selectableOption)
        postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: position + 1))
        
        // 이거 호출되면서 TextField 가 내려감.
        postingBlockCollectionViewCellDelegate?.updateUI(cell: self, cellIndex: cellIndex, postingQuestion: postingQuestion)
    }
}


extension PostingBlockCollectionViewCell: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // return 이 아닌 다른곳 눌러도 이곳 호출됨.
        return dismissKeyboard()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print("return tapped!")
            // TODO: Update PostingQuestion
            guard let cellIndex = cellIndex, let questionText = textView.text, let postingQuestion = postingQuestion else { return false }
            postingBlockCollectionViewCellDelegate?.updateQuestionText(cellIndex: cellIndex, questionText: questionText, postingQuestion: postingQuestion)
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
//            textView.textColor = UIColor.lightGray
            textView.textColor = UIColor(white: 0.7, alpha: 1)
        }
    }
}

extension PostingBlockCollectionViewCell: QuestionTypeOptionStackViewDelegate {
    // change or set initially, 두번째로 호출
    func changeQuestionType(briefQuestionType: BriefQuestionType) {
        print("이거 호출 안되는데? 아니네 되네 ")
        guard let cellIndex = cellIndex else { fatalError() }

        // PostingQuestion 할당된게 있는지 먼저 확인
        if let postingQuestion = postingQuestion {
            
            postingQuestion.modifyQuestionType(briefQuestionType: briefQuestionType)
            // Type 변경!
            
            // 여기에서, 각 BriefQuestionType case에 따라 별로 구분해줘야 할 것 같아.
            
            if postingQuestion.selectableOptions.count == 0 {
                postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
            } else {
                if briefQuestionType == .essay || briefQuestionType == .short {
                    postingQuestion.removeSelectableOptions()
                    postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
                }
            }
            if let questionText = questionTextField.text {
                postingBlockCollectionViewCellDelegate?.updateQuestionText(cellIndex: cellIndex, questionText: questionText, postingQuestion: postingQuestion)
            }
            postingBlockCollectionViewCellDelegate?.setPostingQuestionToIndex(postingQuestion: postingQuestion, index: cellIndex)
            postingBlockCollectionViewCellDelegate?.updateUI(cell: self, cellIndex: cellIndex, postingQuestion: postingQuestion)
            
        } else {
            print("생성!")
            let postingQuestion = PostingQuestion(index: cellIndex, question: questionTextField.text, briefQuestionType: briefQuestionType)
            // 이게 호출될 것 같은데?
            postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
            
            postingBlockCollectionViewCellDelegate?.setPostingQuestionToIndex(postingQuestion: postingQuestion, index: cellIndex)
            postingBlockCollectionViewCellDelegate?.updateUI(cell: self, cellIndex: cellIndex, postingQuestion: postingQuestion)
        }
    }
}
