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
    func updateUI(cellIndex: Int, postingQuestion: PostingQuestion)
    func setPostingQuestionToIndex(postingQuestion: PostingQuestion, index: Int)
}

class PostingBlockCollectionViewCell: UICollectionViewCell {
    var hasPressed = false
    
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
    
    var postingBlockCollectionViewDelegate: PostingBlockCollectionViewCellDelegate?
        
    public var postingQuestion: PostingQuestion? {
        didSet {
            guard let postingQuestion = postingQuestion else { fatalError() }
            initializeStates()
            configure(with: postingQuestion)
        }
    }
    
    private func initializeStates() {
        selectableOptionStackView = SelectableOptionStackView()
    }
    
    public var briefQuestionType: BriefQuestionType {
        return postingQuestion?.briefQuestionType ?? .singleSelection
    }

    private func configure(with postingQuestion: PostingQuestion) {
        
        questionTextField.text = postingQuestion.question
        if questionTextField.text == "" { questionTextField.text = "질문을 입력해주세요." }
        questionTextField.textColor = postingQuestion.question == "질문을 입력해주세요." ? .lightGray : .black
        questionTypeOptionStackView.updateSelectedOption(briefType: postingQuestion.briefQuestionType)
        
        indexLabel.text = "\((postingQuestion.index + 1))."
        
        let numberOfOptionsText = "\(postingQuestion.numberOfOptions) 옵션"
        questionTypeOptionStackView.numberOfSelectableOptionButton.setTitle(numberOfOptionsText, for: .normal)
        
        print("numberOfSelectableOptions: \(postingQuestion.selectableOptions.count)")
        
        postingQuestion.selectableOptions.forEach {
            let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: postingQuestion.briefQuestionType, selectableOption: $0)
            selectableOptionFieldView.selectableOptionFieldDelegate = self
            print("option text: \($0.value), position: \($0.position)")
            selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
//            selectableOptionFieldView.layoutIfNeeded()
        }
        
        addSubview(selectableOptionStackView)
        selectableOptionStackView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(questionTypeOptionStackView.snp.bottom).offset(20)
        }
        
//        selectableOptionStackView.layoutSubviews()
        
//        selectableOptionStackView.layoutIfNeeded()
        
    }
    
    /// starts from 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDelegate()
        setupLayout()
    }
    
    private func setupDelegate() {
        questionTextField.delegate = self
        questionTypeOptionStackView.optionStackViewDelegate = self
//        questionTypeOptionStackView.questionOptionStackViewDelegate = self
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
    
    // 이거.. 음.. 다른 Cell 로 만들 수 있을 것 같은데 ??
    // FIXME: change name to be related to questionType
    private var singleSelection1: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단일 선택", tag: 0)
        return singleSelection
    }()
    
    private var singleSelection2: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "다중 선택", tag: 1)
        return singleSelection
    }()
    
    private var singleSelection3: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "단답형", tag: 2)
        return singleSelection
    }()
    
    private var singleSelection4: PostingSelectionButton = {
        let singleSelection = PostingSelectionButton(text: "서술형", tag: 3)
        return singleSelection
    }()
    
    public var questionTypeOptionStackView: PostingQuestionOptionStackView = {
        let postingOptionStackView = PostingQuestionOptionStackView()
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

        guard let briefQuestionType = BriefQuestionType(rawValue: index) else { fatalError() }

//        postingQuestion?.briefQuestionType = briefQuestionType
//        guard let postingQuestion = postingQuestion else { return }
//        postingQuestion?.modifyQuestionType(briefQuestionType: <#T##BriefQuestionType#>)

        guard let cellIndex = cellIndex else { fatalError() }

        if let postingQuestion = postingQuestion {
            postingQuestion.modifyQuestionType(briefQuestionType: briefQuestionType)

            if postingQuestion.selectableOptions.count == 0 {

//                postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 1))
                postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
            }

            postingBlockCollectionViewDelegate?.setPostingQuestionToIndex(postingQuestion: postingQuestion, index: cellIndex)
            postingBlockCollectionViewDelegate?.updateUI(cellIndex: cellIndex, postingQuestion: postingQuestion)
        } else {
            let postingQuestion = PostingQuestion(index: cellIndex, question: questionTextField.text, questionType: briefQuestionType)
            let numberOfOptions = postingQuestion.numberOfOptions
//            postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 1))
            postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
            postingBlockCollectionViewDelegate?.updateUI(cellIndex: cellIndex, postingQuestion: postingQuestion)
        }
    }
    
    // configure 시, notifyConditionChanged 에서 한번씩 호출.
    private func updateWithQuestionType(tag: Int) {
        notifySelectionChange(to: tag)
    }
    
    // 한번만 호출
    func notifyConditionChange(to condition: Bool) {
        guard let selectedIndex = questionTypeOptionStackView.selectedIndex, condition else { return }
        
        updateWithQuestionType(tag: selectedIndex)
        
        self.layoutSubviews()
    }
}

extension PostingBlockCollectionViewCell: UITextFieldDelegate {
    // Question 에서 return 눌릴 때 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return true }
        
        // FIXME: 음.. 질문을 입력한 후 return 을 눌러도 여기가 호출됨. 그리고, 중간 수정을 하는 경우 어떤 값인지 알 수가 없음. 따라서, Tag 를 넣어줘야함. question: tag: -1
        guard let postingQuestion = postingQuestion else { fatalError() }
        return dismissKeyboard()
    }
}

extension PostingBlockCollectionViewCell: SelectableOptionFieldDelegate {
    // TODO: 다음 selectableOption 값으로 이동
    func selectableOptionFieldReturnTapped(_ text: String, _ position: Int) {
        
        guard let postingQuestion = postingQuestion, let cellIndex = cellIndex else { fatalError() }
        let selectableOption = SelectableOption(position: position, value: text)
        print("position: \(position)")
        postingQuestion.modifySelectableOption(index: position, selectableOption: selectableOption)
        
        postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: position + 1))
        
//        postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 30))
        
        postingBlockCollectionViewDelegate?.updateUI(cellIndex: cellIndex, postingQuestion: postingQuestion)
        
    // TODO: 마지막 Cell 인 경우와 아닌 경우로 분류 필요.
//        let selectableOption = SelectableOption(postion: position, value: text, placeHolder: nil)
//
////        guard let briefQuestionType = briefQuestionType else { fatalError() }
//        guard let briefQuestionType = postingQuestion?.briefQuestionType else { fatalError() }
//
//        if let postingQuestion = postingQuestion {
//            postingQuestion.modifySelectableOption(index: position, selectableOption: selectableOption)
//            postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: position + 1))
//        } else {
//            guard let cellIndex = cellIndex else { fatalError() }
//            guard let briefQuestionTypeIndex = questionTypeOptionStackView.selectedIndex, let briefType = BriefQuestionType(rawValue: briefQuestionTypeIndex) else { fatalError() }
//            let postingQuestion = PostingQuestion(index: cellIndex, questionType: briefType)
//            postingQuestion.addSelectableOption(selectableOption: selectableOption)
//            postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: position + 1))
//
//            self.postingQuestion = postingQuestion
//            postingBlockCollectionViewDelegate?.setPostingQuestionToIndex(postingQuestion: postingQuestion, index: cellIndex)
//        }
//
//        let addedIndex = numberOfSelectableOptions + 1
//
//        switch briefQuestionType {
//            case .singleSelection: // 단일선택
//                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .singleSelection, selectableOption: SelectableOption(position: addedIndex))
//                selectableOptionFieldView.selectableOptionFieldDelegate = self
//
//                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
//
////                numberOfSelectableOptions += 1
//                guard let cellIndex = cellIndex else { fatalError() }
////                postingBlockCollectionViewDelegate?.updateUI(with: numberOfSelectableOptions, cellIndex: cellIndex, questionText: questionTextField.text, type: briefQuestionType)
//
//            case .multipleSelection: // 다중선택
//                let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: .multipleSelection, selectableOption: SelectableOption(position: addedIndex))
//                selectableOptionFieldView.selectableOptionFieldDelegate = self
//
//                selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
//
////                numberOfSelectableOptions += 1
//
//                guard let cellIndex = cellIndex else { fatalError() }
////                postingBlockCollectionViewDelegate?.updateUI(with: numberOfSelectableOptions, cellIndex: cellIndex, questionText: questionTextField.text, type: briefQuestionType)
//
//
//            default: // 단답형, 서술형
//                dismissKeyboard() // dismissKeyboard
//        }
    }
}


extension PostingBlockCollectionViewCell: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // return 이 아닌 다른곳 눌러도 이곳 호출됨.
        guard let text = textView.text else { return true }
        
        // FIXME: 음.. 질문을 입력한 후 return 을 눌러도 여기가 호출됨. 그리고, 중간 수정을 하는 경우 어떤 값인지 알 수가 없음. 따라서, Tag 를 넣어줘야함. question: tag: -1
//        guard let postingQuestion = postingQuestion else { fatalError() }
        
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

extension PostingBlockCollectionViewCell: PostingQuestionOptionStackViewDelegate {
    // change or set initially, 두번째로 호출
    func changeQuestionType(briefQuestionType: BriefQuestionType) {

        guard let cellIndex = cellIndex else { fatalError() }

        if let postingQuestion = postingQuestion {

            postingQuestion.modifyQuestionType(briefQuestionType: briefQuestionType)
            if postingQuestion.selectableOptions.count == 0 {
//                postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 1))
                postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
            }
            postingBlockCollectionViewDelegate?.setPostingQuestionToIndex(postingQuestion: postingQuestion, index: cellIndex)
            postingBlockCollectionViewDelegate?.updateUI(cellIndex: cellIndex, postingQuestion: postingQuestion)
        } else {
            let postingQuestion = PostingQuestion(index: cellIndex, question: questionTextField.text, questionType: briefQuestionType)
            postingQuestion.addSelectableOption(selectableOption: SelectableOption(position: 0))
            postingBlockCollectionViewDelegate?.setPostingQuestionToIndex(postingQuestion: postingQuestion, index: cellIndex)
            postingBlockCollectionViewDelegate?.updateUI(cellIndex: cellIndex, postingQuestion: postingQuestion)
        }
    }

    // FIXME: Something went wrong ...
    // TODO: Change selectableOptions
//    func changeQuestionType(briefType: BriefQuestionType) {
//        print("type changed to \(briefType)")
//        guard let questionIndex = cellIndex else { fatalError() }
//        var numberOfOptions: Int
//        guard let postingQuestion = postingQuestion else { return }
//        let previousType = postingQuestion.briefQuestionType
//        print("previous: \(previousType), briefType: \(briefType)")
//
//        switch (previousType, briefType) {
//            case (.singleSelection, .multipleSelection), (.multipleSelection, .singleSelection):
//                selectableOptionStackView.selectableOptionFieldViews.forEach { $0.briefQuestionType = briefType }
//                numberOfOptions = selectableOptionStackView.subviews.count
//            case (_, .others):
//                let tobeRemoved = selectableOptionStackView.selectableOptionFieldViews
//                tobeRemoved.forEach {
//                    selectableOptionStackView.removeArrangedSubview($0)
//                    $0.removeFromSuperview()
//                }
//                numberOfOptions = 1
//            default:
//                numberOfOptions = 1
//        }
//
//        postingBlockCollectionViewDelegate?.updateUI(with: numberOfOptions, cellIndex: questionIndex, questionText: questionTextField.text, type: briefType)
//    }

//    func makeSelectableOptions(numberOfOptions: Int, type: BriefQuestionType) {
//        for i in 1 ... numberOfOptions {
////            let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: type, position: i)
//            let selectableOptionFieldView = SelectableOptionFieldView(briefQuestionType: type, selectableOption: SelectableOption(position: i))
//            selectableOptionFieldView.selectableOptionFieldDelegate = self
//            selectableOptionStackView.addSelectableOptionView(selectableOptionFieldView)
////            numberOfSelectableOptions += 1
//        }
//        guard let questionIndex = cellIndex else { fatalError() }
//        postingBlockCollectionViewDelegate?.updateUI(with: numberOfOptions, cellIndex: questionIndex, questionText: questionTextField.text, type: type)
//    }
}
